#!/bin/bash

# Gen ssh key
ssh-keygen -t rsa -q -f "/home/ubuntu/.ssh/id_rsa" -N ""

# Install dev deps
# wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c "echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list"

sudo apt-get update -y && sudo apt install -y \
    python \
    python3 \
    python-pip \
    python3-pip \
    awscli \
    openjdk-8-jdk \
    jenkins \
    mosh \
    nginx \
    supervisor

# Install pipenv
pip3 install pipenv

# Gen jenkins ssh key
sudo -u jenkins ssh-keygen -t rsa -q -f "/var/lib/jenkins/.ssh/id_rsa" -N ""

# sudo cat /var/lib/jenkins/.ssh/id_rsa.pub
mkdir /home/ubuntu/.aws
sudo chown jenkins:jenkins -R /home/ubuntu/.aws
sudo ls -s /home/ubuntu/.aws/ /var/lib/jenkins/

#
sudo apt-get update -y && sudo apt install -y jenkins
# sudo cat /var/lib/jenkins/secrets/initialAdminPassword
