#!/bin/bash

echo "Resetting variables"
rm -rf var; mkdir var

echo "Creating network..."
vpcId=`aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text`
echo $vpcId > var/id.vpc
aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-support "{\"Value\":true}"
aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-hostnames "{\"Value\":true}"
echo "VPC ID is $vpcId"

internetGatewayId=`aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text`
aws ec2 attach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcId
echo $internetGatewayId > var/id.internetgateway
echo "Internet Gateway ID is $internetGatewayId"

subnetId=`aws ec2 create-subnet --vpc-id $vpcId --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text`
echo $subnetId > var/id.subnet
echo "Subnet ID is $subnetId"

routeTableId=`aws ec2 create-route-table --vpc-id $vpcId --query 'RouteTable.RouteTableId' --output text`
echo $routeTableId > var/id.routetable
echo "Route Table ID is $routeTableId"

_=`aws ec2 create-route --route-table-id $routeTableId --destination-cidr-block 0.0.0.0/0 --gateway-id $internetGatewayId`
_=`aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnetId`

myIp=`curl http://ipinfo.io/ip`
echo $myIp > var/ip.me
echo "Your IP is $myIp"

securityGroupId1=`aws ec2 create-security-group --group-name Dev-group --description "Dev Server" --vpc-id $vpcId --query 'GroupId' --output text`
echo $securityGroupId1 > var/id.securitygroup1
echo "Security Group 1 ID is $securityGroupId1"
aws ec2 authorize-security-group-ingress --group-id $securityGroupId1 --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $securityGroupId1 --protocol tcp --port 22 --cidr $myIp/32
aws ec2 authorize-security-group-ingress --group-id $securityGroupId1 --protocol tcp --port 80 --cidr $myIp/32
aws ec2 authorize-security-group-ingress --group-id $securityGroupId1 --protocol tcp --port 8000 --cidr $myIp/32
aws ec2 authorize-security-group-ingress --group-id $securityGroupId1 --protocol tcp --port 8080 --cidr $myIp/32
aws ec2 authorize-security-group-ingress --group-id $securityGroupId1 --protocol udp --port 60000-61000 --cidr $myIp/32
aws ec2 authorize-security-group-ingress --group-id $securityGroupId1 --protocol tcp --port 8080 --cidr 192.30.252.0/22
aws ec2 authorize-security-group-ingress --group-id $securityGroupId1 --protocol tcp --port 8080 --cidr 185.199.108.0/22

securityGroupId2=`aws ec2 create-security-group --group-name Prod-group --description "Prod Server" --vpc-id $vpcId --query 'GroupId' --output text`
echo $securityGroupId2 > var/id.securitygroup2
echo "Security Group 2 ID is $securityGroupId2"
aws ec2 authorize-security-group-ingress --group-id $securityGroupId2 --protocol tcp --port 22 --cidr $myIp/32
aws ec2 authorize-security-group-ingress --group-id $securityGroupId2 --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $securityGroupId2 --protocol tcp --port 80 --cidr 0.0.0.0/0

loadBalancerName=my-load-balancer
echo $loadBalancerName > var/name.loadbalancer
loadBalacerUrl=`aws elb create-load-balancer --load-balancer-name $loadBalancerName --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets $subnetId --security-groups $securityGroupId2 --query 'DNSName'`
echo $loadBalacerUrl | tr -d '"' > var/url.loadbalancer
echo "Load Balancer $loadBalancerName created"

echo "Done!"
echo "You can now launch the Dev Server!"
