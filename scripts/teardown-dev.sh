#!/bin/bash

echo "Loading"
source scripts/vars.sh

echo "Terminating..."
aws ec2 terminate-instances --instance-ids $instanceId1

echo "Done!"
