#!/bin/bash

if [ -z "$1" ]
  then
    echo "Please specify cluster name like check_ecs_tasks.sh <cluster-name>"
    exit 1
fi

cluster=$1
service=arms-cloud-service

# aws ecs list-tasks --cluster $cluster
desiredCount=$(aws ecs describe-services --services arms-cloud-service --cluster $cluster | jq '.services[0].desiredCount')
echo "Desired Count: ${desiredCount}"

for task in `aws ecs list-tasks --cluster $cluster  | jq -r '.taskArns | .[]'`
do
 taskinfo=$(aws ecs describe-tasks --cluster $cluster --tasks $task)
 taskArn=$(echo $taskinfo | jq  -r '.tasks[0].taskArn' | sed  s/arn.*task// | tr -d /)
 service=$(echo $taskinfo | jq  -r '.tasks[0].group' | awk -F: '{print $2}')
 taskStatus=$(echo $taskinfo | jq  -r '.tasks[0].lastStatus')
 taskIP=$(echo $taskinfo | jq  -r '.tasks[0].containers[0].networkInterfaces[0].privateIpv4Address')
 interface=$(echo $taskinfo | jq  -r '.tasks[0].attachments[0].details[1].value')
 globalIP=$(aws ec2 describe-network-interfaces --network-interface-ids $interface | jq -r '.NetworkInterfaces[0].Association.PublicIp')
 vins=$(curl -s http://${globalIP}:22222/vins)
 totalvins=$(echo $vins | sed -e s/{\"vins\"://g | tr -d [  | tr -d ] | sed -e s/}// | awk -F ',' '{ print NF}')

 echo "- $taskArn $service $taskStatus $taskIP $globalIP"
 echo "  total vins: ${totalvins}"
 echo "    $vins"

 echo ""
 echo ""
done
