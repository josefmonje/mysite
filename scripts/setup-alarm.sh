#!/bin/bash

echo "Creating SNS topic"
alarmName1=status-mon
alarmName2=disk-mon
snsArn1=`aws sns create-topic --name $alarmName1 --query 'TopicArn' | tr -d '"'`
snsArn2=`aws sns create-topic --name $alarmName2 --query 'TopicArn' | tr -d '"'`
echo "Dome"

echo "Subscribing to SNS topic"
aws sns subscribe --topic-arn $snsArn1 --protocol email --notification-endpoint josefmonje@gmail.com
aws sns subscribe --topic-arn $snsArn2 --protocol email --notification-endpoint josefmonje@gmail.com
echo "Done. Please check your email!"

echo "Enabling Metric Alarms..."
aws cloudwatch put-metric-alarm --alarm-name status-mon-1 --alarm-description "Alarm when Prod 1 isn't running" --metric-name StatusCheckFailed --namespace AWS/EC2 --statistic Maximum --period 60 --threshold 1 --comparison-operator GreaterThanOrEqualToThreshold --dimensions "Name=InstanceId,Value=$instanceId2" --evaluation-periods 1 --alarm-actions $snsArn1 --unit Count --treat-missing-data breaching

aws cloudwatch put-metric-alarm --alarm-name status-mon-2 --alarm-description "Alarm when Prod 2 isn't running" --metric-name StatusCheckFailed --namespace AWS/EC2 --statistic Maximum --period 60 --threshold 1 --comparison-operator GreaterThanOrEqualToThreshold --dimensions "Name=InstanceId,Value=$instanceId3" --evaluation-periods 1 --alarm-actions $snsArn1 --unit Count --treat-missing-data breaching

aws cloudwatch put-metric-alarm --alarm-name disk-mon-1 --alarm-description "Alarm when Prod 1 storage exceeds 80%" --metric-name DiskSpaceUtilization --namespace System/Linux --statistic Maximum --period 60 --threshold 80 --comparison-operator GreaterThanThreshold --evaluation-periods 1 --alarm-actions $snsArn2 --unit Percent --dimensions Name=InstanceId,Value=$instanceId2 Name=MountPath,Value=/ Name=Filesystem,Value=/dev/xvda1

aws cloudwatch put-metric-alarm --alarm-name disk-mon-2  --alarm-description "Alarm when Prod 2 storage exceeds 80%" --metric-name DiskSpaceUtilization --namespace System/Linux --statistic Maximum --period 60 --threshold 80 --comparison-operator GreaterThanThreshold --evaluation-periods 1 --alarm-actions $snsArn2 --unit Percent --dimensions Name=InstanceId,Value=$instanceId3 Name=MountPath,Value=/ Name=Filesystem,Value=/dev/xvda1
echo "Done."
