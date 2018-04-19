#!/bin/bash

echo "Loading"
source scripts/vars.sh

echo "Setting up Prod Server 1..."
instanceId2=`aws ec2 run-instances --image-id $amiId --count 1 --instance-type t2.nano --key-name $keyName --security-group-ids $securityGroupId2 --subnet-id $subnetId --associate-public-ip-address --query 'Instances[0].InstanceId' --output text`
instance2Url=`aws ec2 describe-instances --instance-ids $instanceId2 --query 'Reservations[0].Instances[0].PublicDnsName' --output text`
echo $instanceId2 > var/id.instance2
echo $instance2Url > var/url.instance2
echo "Prod Server 1 ($instanceId2) at $instance2Url"

echo "Adding Dev to authorized keys"
cat $myPubKey | ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance2Url 'cat >> ~/.ssh/authorized_keys'

echo "Adding Jenkins to authorized keys"
echo $sshJenkins | ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance2Url 'cat >> ~/.ssh/authorized_keys'

echo "Installing..."
ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance2Url '
  mkdir var; \
  sudo apt-get update && sudo apt-get install -y unzip libwww-perl libdatetime-perl python python3 python-pip python3-pip nginx supervisor; \
  pip3 install pipenv; \
  curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O; \
  unzip CloudWatchMonitoringScripts-1.2.2.zip && rm CloudWatchMonitoringScripts-1.2.2.zip; \
  sudo rm /etc/nginx/sites-available/default; \
'

echo "Sending AWS monitoring credentials"
scp -i $keyFile -o StrictHostKeyChecking=no ~/.aws/awscreds.conf ubuntu@$instance2Url:~/aws-scripts-mon/

echo "Retrieving Prod 1 IP address"
prod1Ip=`ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance2Url 'curl http://instance-data/latest/meta-data/public-ipv4'`
echo $prod1Ip > var/ip.instance2
echo "IP address is $prod1Ip"

echo "Setting up Prod Server 2..."
instanceId3=`aws ec2 run-instances --image-id $amiId --count 1 --instance-type t2.nano --key-name $keyName --security-group-ids $securityGroupId2 --subnet-id $subnetId --associate-public-ip-address --query 'Instances[0].InstanceId' --output text`
instance3Url=`aws ec2 describe-instances --instance-ids $instanceId3 --query 'Reservations[0].Instances[0].PublicDnsName' --output text`
echo $instanceId3 > var/id.instance3
echo $instance3Url > var/url.instance3
echo "Prod Server 2 ($instanceId3) at $instance3Url"

echo "Adding Dev to authorized keys"
cat $myPubKey | ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance3Url 'cat >> ~/.ssh/authorized_keys'

echo "Adding Jenkins to authorized keys"
echo $sshJenkins | ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance3Url 'cat >> ~/.ssh/authorized_keys'

echo "Installing..."
ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance3Url '
  mkdir var; \
  sudo apt-get update && sudo apt-get install -y unzip libwww-perl libdatetime-perl python python3 python-pip python3-pip nginx supervisor; \
  pip3 install pipenv; \
  curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O; \
  unzip CloudWatchMonitoringScripts-1.2.2.zip && rm CloudWatchMonitoringScripts-1.2.2.zip; \
  sudo rm /etc/nginx/sites-available/default; \
'
echo "Sending AWS monitoring credentials"
scp -i $keyFile -o StrictHostKeyChecking=no ~/.aws/awscreds.conf ubuntu@$instance3Url:~/aws-scripts-mon/

echo "Retrieving Prod 2 IP address"
prod2Ip=`ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance3Url 'curl http://instance-data/latest/meta-data/public-ipv4'`
echo $prod2Ip > var/ip.instance3
echo "IP address is $prod2Ip"

echo "Disabling termination"
aws ec2 modify-instance-attribute --instance-id $instanceId2 --disable-api-termination
aws ec2 modify-instance-attribute --instance-id $instanceId3 --disable-api-termination
echo "Termination is disabled"

echo "Sending variables..."
scp -i $keyFile -o StrictHostKeyChecking=no var/* ubuntu@$instance1Url:var/.
scp -i $keyFile -o StrictHostKeyChecking=no var/* ubuntu@$instance2Url:var/.
scp -i $keyFile -o StrictHostKeyChecking=no var/* ubuntu@$instance3Url:var/.

scp -i $keyFile -o StrictHostKeyChecking=no .env ubuntu@$instance2Url:var/.
scp -i $keyFile -o StrictHostKeyChecking=no .env ubuntu@$instance3Url:var/.

echo "Done!"
echo "You can now test Jenkins deployment after setting up the github webhook!"
echo "IP addresses are: $prod1Ip and $prod2Ip"
