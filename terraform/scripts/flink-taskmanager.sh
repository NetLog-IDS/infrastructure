#!/bin/bash
JOB_MANAGER_IP=$1
sudo docker run -d \
  --name taskmanager \
  --hostname taskmanager \
  -e FLINK_PROPERTIES="jobmanager.rpc.address: $JOB_MANAGER_IP
taskmanager.numberOfTaskSlots: 6" \
  flink:1.18.1-java11 \
  taskmanager
