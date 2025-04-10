#!/bin/bash
JOB_MANAGER_IP=$1
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
