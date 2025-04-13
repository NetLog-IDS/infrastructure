#!/bin/bash
KAFKA_IP=$1

sudo docker network create monitoring-network

docker run -d \
  --name mongodb \
  --network monitoring-network \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  mongo

sudo docker run -d \
    --name monitoring \
    --hostname monitoring \
    -p 8000:8000 \
    -e KAFKA_BROKER=$KAFKA_IP \
    -e CONNECTION_STRING="mongodb://mongoadmin:secret@mongodb:27017" \
    -e MAIL_USERNAME="to be added" \
    -e MAIL_PASSWORD="to be added (google email token)" \
    -e MAIL_FROM="ta.at.jomama@gmail.com" \
    -e MAIL_PORT="587" \
    -e MAIL_SERVER="smtp.gmail.com" \
    johannessetiawan/monitoring-netlog