#!/bin/bash
SELF_IP=$1
KAFKA_IP=$2
KAFKA_HQ_IP=$3

sudo docker pull flink:1.18.1-java11
sudo docker pull emyr298/prediction

while ! nc -z $KAFKA_IP 19092; do sleep 5; echo 'Waiting for Kafka...'; done
while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://$KAFKA_HQ_IP:8082/docker-kafka-server/topic/network-traffic)" != "200" ]]; do sleep 5; echo 'Waiting for Kafka topic network-traffic...'; done
while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://$KAFKA_HQ_IP:8082/docker-kafka-server/topic/network-flows)" != "200" ]]; do sleep 5; echo 'Waiting for Kafka topic network-flows...'; done
while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://$KAFKA_HQ_IP:8082/docker-kafka-server/topic/PORT_SCAN)" != "200" ]]; do sleep 5; echo 'Waiting for Kafka topic PORT_SCAN...'; done
while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://$KAFKA_HQ_IP:8082/docker-kafka-server/topic/DOS)" != "200" ]]; do sleep 5; echo 'Waiting for Kafka topic DOS...'; done

sudo docker run -d \
  --name jobmanager \
  --hostname jobmanager \
  -p 8082:8082 \
  -p 6123:6123 \
  -p 6124:6124 \
  -e FLINK_PROPERTIES="jobmanager.rpc.address: $SELF_IP
rest.address: $SELF_IP
jobmanager.memory.process.size: 2048m
rest.port: 8082" \
  flink:1.18.1-java11 \
  jobmanager

sudo docker run -d \
  --name taskmanager \
  --hostname taskmanager \
  -e FLINK_PROPERTIES="jobmanager.rpc.address: $SELF_IP
taskmanager.numberOfTaskSlots: 6
taskmanager.memory.process.size: 2048m" \
  flink:1.18.1-java11 \
  taskmanager

sudo docker run -d \
  --name portscan_prediction \
  --hostname portscan \
  -e BOOTSTRAP_SERVER=$KAFKA_IP:19092 \
  -e OUTPUT_TOPIC=PORT_SCAN \
  emyr298/prediction

sudo docker run -d \
  --name dos_prediction \
  --hostname dos \
  -e BOOTSTRAP_SERVER=$KAFKA_IP:19092 \
  -e OUTPUT_TOPIC=DOS \
  emyr298/prediction
