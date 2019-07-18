#!/bin/bash

if [ -z "$1" ]
  then
    echo "Please specify cluster name like check_ecs_tasks.sh <cluster-name>"
    exit 1
fi

cluster=$1

for task in `aws ecs list-tasks --cluster $cluster  | jq -r '.taskArns | .[]'`
do
 taskinfo=$(aws ecs describe-tasks --cluster $cluster --tasks $task)
 taskArn=$(echo $taskinfo | jq  -r '.tasks[0].taskArn' | sed  s/arn.*task// | tr -d /)
 taskStatus=$(echo $taskinfo | jq  -r '.tasks[0].lastStatus')
 taskIP=$(echo $taskinfo | jq  -r '.tasks[0].containers[0].networkInterfaces[0].privateIpv4Address')
 echo "$taskArn $taskStatus $taskIP"
done
