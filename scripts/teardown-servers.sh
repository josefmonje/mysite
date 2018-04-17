#!/bin/bash

echo "Loading"
source scripts/vars.sh

echo "Enabling termination"
aws ec2 modify-instance-attribute --instance-id $instanceId2 --no-disable-api-termination
aws ec2 modify-instance-attribute --instance-id $instanceId3 --no-disable-api-termination

echo "Terminating..."
aws ec2 terminate-instances --instance-ids $instanceId1
aws ec2 terminate-instances --instance-ids $instanceId2
aws ec2 terminate-instances --instance-ids $instanceId3

echo "Done!"
echo "You can now teardown the network!"
