#!/bin/bash
JOB_MANAGER_IP=$1

sudo docker pull flink:1.18.1-java11
while ! nc -z $KAFKA_IP 19092; do sleep 5; echo 'Waiting for Kafka...'; done

sudo docker run -d \
  --name jobmanager \
  --hostname jobmanager \
  -p 8084:8082 \
  -p 6123:6123 \
  -p 6124:6124 \
  -e FLINK_PROPERTIES="jobmanager.rpc.address: $JOB_MANAGER_IP
rest.address: $JOB_MANAGER_IP
jobmanager.memory.process.size: 2048m
rest.port: 8082" \
  flink:1.18.1-java11 \
  jobmanager
