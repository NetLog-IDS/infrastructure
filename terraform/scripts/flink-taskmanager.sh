#!/bin/bash
JOB_MANAGER_IP=$1

sudo docker pull flink:1.18.1-java11
while ! nc -z $KAFKA_IP 19092; do sleep 5; echo 'Waiting for Kafka...'; done

sudo docker run -d \
  --name taskmanager \
  --hostname taskmanager \
  -e FLINK_PROPERTIES="jobmanager.rpc.address: $JOB_MANAGER_IP
taskmanager.numberOfTaskSlots: 6
taskmanager.memory.process.size: 2048m" \
  flink:1.18.1-java11 \
  taskmanager
