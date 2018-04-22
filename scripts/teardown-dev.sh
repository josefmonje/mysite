#!/bin/bash

echo "Loading"
source scripts/vars.sh

echo "Terminating..."
aws ec2 terminate-instances --instance-ids $instanceId1

echo "Deleting key pair"
aws ec2 delete-key-pair --key-name $keyPairName

echo "Deleting key file"
sudo rm $keyFile

echo "Done!"
