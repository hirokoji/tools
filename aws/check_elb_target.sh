#!/bin/bash

if [ -z "$1" ]
  then
    echo "Please specify target Arn of ELB like check_elb_target.sh <target-arn>"
    exit 1
fi

targetArn=$1

targetInfo=$(aws elbv2 describe-target-health --target-group-arn $targetArn )
numOfTasks=$(echo $targetInfo | jq -r '.TargetHealthDescriptions | length')

echo $targetInfo | jq -c '.TargetHealthDescriptions[] | [ .Target.Id, .TargetHealth.State ]'
