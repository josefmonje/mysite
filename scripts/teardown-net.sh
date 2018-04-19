#!/bin/bash

echo "Loading"
source scripts/vars.sh

echo "Tearing down..."

echo "Deleting Internet Gateway"
aws ec2 detach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcId
aws ec2 delete-internet-gateway --internet-gateway-id $internetGatewayId

echo "Deleting Load Balancer"
aws elb delete-load-balancer --load-balancer-name my-load-balancer

echo "Deleting Security Groups"
aws ec2 delete-security-group --group-id $securityGroupId1
aws ec2 delete-security-group --group-id $securityGroupId2

echo "Deleting Subnet"
aws ec2 delete-subnet --subnet-id $subnetId

echo "Deleting Subnet"
aws ec2 delete-route-table --route-table-id $routeTableId

echo "Deleting VPC"
aws ec2 delete-vpc --vpc-id $vpcId

echo "Deleting DHCP Options"
dopt=`aws ec2 describe-dhcp-options --query 'DhcpOptions[0].DhcpOptionsId' | tr -d '"'`
aws ec2 delete-dhcp-options --dhcp-options-id $dopt

echo "Done!"
echo "That's it!"
