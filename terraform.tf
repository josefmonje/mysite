## For reference:
## https://hackernoon.com/manage-aws-vpc-as-infrastructure-as-code-with-terraform-55f2bdb3de2a

# Variables
variable "aws_region" {
  description = "Region for the VPC"
  default = "ap-southeast-1"
}

variable "aws_availability_zone" {
  description = "Region for the Subnet"
  default = "ap-southeast-1a"
}

variable "all_cidr" {
  description = "CIDR for All"
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR for the default subnet"
  default = "10.0.1.0/24"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default = "ami-52d4802e"
  # default = "ami-06067854"
}

variable "instance_type" {
  description = "Amazon Linux AMI Instance Type"
  default = "t2.nano"
  # default = "t2.micro"
}

variable "webserver_count" {
  description = "Number of webservers to be deployed"
  default = 1
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/Users/josefmonje/.ssh/id_rsa.pub"
}

# data "http" "icanhazip" {
#    url = "http://icanhazip.com"
# }


# Provider
# Define AWS as our provider
provider "aws" {
  region = "${var.aws_region}"
}

# Resources
# Define our VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "My VPC"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "VPC Internet Gateway"
  }
}

# Define the route table
resource "aws_route_table" "route_table" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "${var.all_cidr}"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }

  tags {
    Name = "Default Subnet Route Table"
  }
}

# Define the default subnet
resource "aws_subnet" "default" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.subnet_cidr}"
  availability_zone = "${var.aws_availability_zone}"

  tags {
    Name = "Default Subnet"
  }
}

# Assign the route table to the subnet
resource "aws_route_table_association" "default" {
  subnet_id = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.route_table.id}"
}


# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "vpctestkeypair"
  public_key = "${file("${var.key_path}")}"
}


# Define the security group for private subnet
resource "aws_security_group" "private" {
  name = "private"
  description = "Allow traffic from Developer"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.all_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.all_cidr}"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${var.all_cidr}"]
  }

  ingress {
    from_port = 60000
    to_port = 61000
    protocol = "udp"
    cidr_blocks = ["${var.all_cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.all_cidr}"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "Private Group"
  }
}

# Define the security group for public subnet
resource "aws_security_group" "public" {
  name = "public"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.all_cidr}"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.all_cidr}"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.all_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.subnet_cidr}","${var.all_cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.all_cidr}"]
  }

  vpc_id="${aws_vpc.default.id}"

  tags {
    Name = "Public Group"
  }
}

# Define development server inside the subnet
resource "aws_instance" "development" {
  ami  = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "${file("scripts/install_dev.sh")}"

  tags {
    Name = "Dev Server"
  }
}

# Define webservers inside the subnet
resource "aws_instance" "webserver" {
  count = "${var.webserver_count}"
  ami  = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.default.id}"
  subnet_id = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  associate_public_ip_address = true
  source_dest_check = false
  user_data = "${file("scripts/install_web.sh")}"

  tags {
    Name = "Webserver ${count.index}"
  }
}

# Define outputs
output "Dev IP" {
  value = "${aws_instance.development.public_ip}"
}

output "Web private IPs" {
  value = "${join(", ", aws_instance.webserver.*.private_ip)}"
}

output "Web public IPs" {
  value = "${join(", ", aws_instance.webserver.*.public_ip)}"
}
