#!/bin/bash

echo "Loading"
source scripts/vars.sh
# echo "Creating key"
# aws ec2 create-key-pair --key-name $keyName --query 'KeyMaterial' --output text > $keyFile
# chmod 400 $keyFile

echo "Setting up Dev Server..."
instanceId1=`aws ec2 run-instances --image-id $amiId --count 1 --instance-type t2.nano --key-name $keyName --security-group-ids $securityGroupId1 --subnet-id $subnetId --associate-public-ip-address --query 'Instances[0].InstanceId' --output text`
instance1Url=`aws ec2 describe-instances --instance-ids $instanceId1 --query 'Reservations[0].Instances[0].PublicDnsName' --output text`
echo $instanceId1 > var/id.instance1
echo $instance1Url > var/url.instance1
echo "Dev Server ($instanceId1) at $instance1Url"

echo "Adding Me to authorized keys"
cat $myPubKey | ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance1Url 'cat >> ~/.ssh/authorized_keys'

echo "Generating Dev ssh key"
ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance1Url '
  ssh-keygen -t rsa -q -f "/home/ubuntu/.ssh/id_rsa" -N ""; \
  cat ${HOME}/.ssh/id_rsa.pub; \
' > var/ssh-key.dev
echo "Dev ssh key generated"

echo "Retrieving Dev IP address"
devIp=`ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance1Url 'curl http://instance-data/latest/meta-data/public-ipv4'`
echo $devIp > var/ip.instance1
echo "IP address is $devIp"

echo "Installing..."
ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance1Url '
  sudo fallocate -l 2G /swapfile; \
  sudo chmod 600 /swapfile; \
  sudo mkswap /swapfile; \
  sudo swapon /swapfile; \
  mkdir var; \
  mkdir ~/.aws; \
  wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -; \
  sudo sh -c "echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list"; \
  sudo apt-get update -y && sudo apt install -y python python3 python-pip python3-pip awscli jenkins mosh nginx supervisor; \
  pip3 install pipenv; \
'
echo "Done installing"

echo "Generating Jenkins ssh key"
ssh -i $keyFile -o StrictHostKeyChecking=no ubuntu@$instance1Url '
  sudo -u jenkins ssh-keygen -t rsa -q -f "/var/lib/jenkins/.ssh/id_rsa" -N ""; \
  sudo cat /var/lib/jenkins/.ssh/id_rsa.pub; \
' > var/ssh-key.jenkins
echo "Jenkins ssh key generated"

echo "Sending AWS credentials"
scp -i $keyFile -o StrictHostKeyChecking=no ~/.aws/credentials ubuntu@$instance1Url:~/.aws
echo "Assigning aws creds to Jenkins"
ssh -i $keyFile ubuntu@$instance1Url '
  sudo chown jenkins:jenkins -R ~/.aws; \
  sudo mv ~/.aws/ /var/lib/jenkins/; \
'
echo "Done"

echo "Adding to security groups"
aws ec2 authorize-security-group-ingress --group-id $securityGroupId1 --protocol tcp --port 8080 --cidr $devIp/32
aws ec2 authorize-security-group-ingress --group-id $securityGroupId2 --protocol tcp --port 22 --cidr $devIp/32

echo "Sending variables..."
scp -i $keyFile -o StrictHostKeyChecking=no var/* ubuntu@$instance1Url:var/.

jenkinsPassword=`ssh -i $keyFile ubuntu@$instance1Url 'sudo cat /var/lib/jenkins/secrets/initialAdminPassword'`
echo $jenkinsPassword > var/password.jenkins
echo "Done!"
echo "Please setup Jenkins while setting up prod servers!"
echo "Visit: $instance1Url:8080"
echo "Your Jenkins password is $jenkinsPassword"
