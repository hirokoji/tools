#!/bin/bash

if [ -z "$1" ]
  then
    echo "Please specify cluster name like check_cpu_utilization.sh <cluster-name>"
    exit 1
fi
if [ -z "$2" ]
  then
    echo "Please specify service name like check_cpu_utilization.sh <service-name>"
    exit 1
fi



currentTime=$(date +"%Y-%m-%dT%TZ")
beforeTime=$(date -v -1M +"%Y-%m-%dT%TZ")
clusterName=$1
serviceName=$2
#clusterName="drgdoesitwork-arms	"
#serviceName="arms-cloud-service"

aws cloudwatch get-metric-statistics --metric-name "CPUUtilization" --start-time $beforeTime --end-time $currentTime --period 60 --namespace "AWS/ECS" --statistics Average --dimensions Name=ServiceName,Value=$serviceName Name=ClusterName,Value=$clusterName |  jq '.Datapoints[0].Average'