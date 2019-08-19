#!/bin/bash
if [ -z "$1" ]
  then
    echo "Please specify stackname like aws.sh <stack-name>"
    exit 1
fi
if [ -z "$2" ]
  then
    waitSecond=5
  else
    waitSecond=$2
fi


export targetGroupArn=$(echo $stackInfo | jq  -r '.Stacks[0].Outputs[0].OutputValue')
export clusterName=$(echo $stackInfo | jq  -r '.Stacks[0].Outputs[4].OutputValue')
export serviceName=$(echo $stackInfo | jq  -r '.Stacks[0].Outputs[5].OutputValue')

echo $stackInfo | jq  -r '.Stacks[0].Outputs[2].OutputValue'


echo "wait time: $waitSecond (s)"


while :
do
    stackInfo=$(aws cloudformation describe-stacks --stack-name $1)
    export targetGroupArn=$(echo $stackInfo | jq  -r '.Stacks[0].Outputs[0].OutputValue')
    export clusterName=$(echo $stackInfo | jq  -r '.Stacks[0].Outputs[4].OutputValue' | sed -e s/arn.*cluster// | tr -d /)
    export serviceName=$(echo $stackInfo | jq  -r '.Stacks[0].Outputs[5].OutputValue')

    echo "----"
    date -u +"%Y-%m-%dT%TZ"

    echo "##CPU Utlization Average"
    ./check_cpu_utilization.sh $clusterName 
    echo ""
    
    echo "##ELB Target Group Status"
    ./check_elb_target.sh $targetGroupArn
    echo ""
    
    echo "##ECS Status"
    ./check_ecs_tasks.sh  $clusterName
    echo ""

    sleep $waitSecond

done

# TODO
## check log of deregister
## check log of killer
## check log of ecs containers

