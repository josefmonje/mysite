#!/bin/bash

# Network
vpcId=`cat var/id.vpc`
internetGatewayId=`cat var/id.internetgateway`
loadBalancerName=`cat var/name.loadbalancer`
securityGroupId1=`cat var/id.securitygroup1`
securityGroupId2=`cat var/id.securitygroup2`
subnetId=`cat var/id.subnet`
routeTableId=`cat var/id.routetable`

# Dev
myPubKey=~/.ssh/id_rsa.pub
myIp=`cat var/ip.me`
devIp=`cat var/ip.instance1`
instanceId1=`cat var/id.instance1`
instance1Url=`cat var/url.instance1`

# Prod
amiId=ami-52d4802e
keyName=test-key-pair
keyFile=~/.ssh/test-key.pem
sshJenkins=`cat var/ssh-key.jenkins`

instanceId2=`cat var/id.instance2`
instance2Url=`cat var/url.instance2`
instanceId3=`cat var/id.instance3`
instance3Url=`cat var/url.instance3`

# SNS
snsArn1=`cat var/sns.status`
snsArn2=`cat var/sns.disk`
