#!/bin/bash

echo "Loading"
source scripts/vars.sh

echo "Deleting Topics"
aws sns delete-topic --topic-arn $snsArn1
aws sns delete-topic --topic-arn $snsArn2
echo "Done"

echo "Unsubscribing"
aws sns unsubscribe --subscription-arn $snsArn1
aws sns unsubscribe --subscription-arn $snsArn2
echo "Done"

# Delete alarms
