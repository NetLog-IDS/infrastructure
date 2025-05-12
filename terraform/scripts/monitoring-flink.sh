#!/bin/bash
KAFKA_IP=$1
KAFKA_HQ_IP=$2
MONITORING_IP=$3

sudo docker pull johannessetiawan/monitoring-netlog
sudo docker pull mongo

while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://$KAFKA_HQ_IP:8082/docker-kafka-server/topic/network-traffic)" != "200" ]]; do sleep 5; echo 'Waiting for Kafka topic network-traffic...'; done
while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://$KAFKA_HQ_IP:8082/docker-kafka-server/topic/network-flows)" != "200" ]]; do sleep 5; echo 'Waiting for Kafka topic network-flows...'; done
while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://$KAFKA_HQ_IP:8082/docker-kafka-server/topic/PORT_SCAN)" != "200" ]]; do sleep 5; echo 'Waiting for Kafka topic PORT_SCAN...'; done
while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://$KAFKA_HQ_IP:8082/docker-kafka-server/topic/DOS)" != "200" ]]; do sleep 5; echo 'Waiting for Kafka topic DOS...'; done

sudo docker network create monitoring-network

sudo docker run -d \
  --name mongodb \
  --network monitoring-network \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  -p 27017:27017 \
  mongo

sudo docker run -d \
    --name monitoring \
    --hostname monitoring \
    -p 8000:8000 \
    -e KAFKA_BROKER=$KAFKA_IP:19092 \
    -e CONNECTION_STRING="mongodb://mongoadmin:secret@$MONITORING_IP:27017" \
    -e MAIL_USERNAME="ta.at.jomama@gmail.com" \
    -e MAIL_PASSWORD="dlmfhggzesmsqclm" \
    -e MAIL_FROM="ta.at.jomama@gmail.com" \
    -e MAIL_PORT="587" \
    -e MAIL_SERVER="smtp.gmail.com" \
    johannessetiawan/monitoring-netlog
