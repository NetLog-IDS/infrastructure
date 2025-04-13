#!/bin/bash
HOST_IP=$1
ZOOKEEPER_IP=$2
sudo docker run --name kafka \
    --hostname kafka \
    -p 19092:19092 \
    -e "KAFKA_BROKER_ID=101" \
    -e "KAFKA_ZOOKEEPER_CONNECT=$ZOOKEEPER_IP:2181" \
    -e "KAFKA_ADVERTISED_LISTENERS=INTERNAL://kafka:9092,EXTERNAL://${HOST_IP:-127.0.0.1}:19092" \
    -e "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT" \
    -e "KAFKA_INTER_BROKER_LISTENER_NAME=INTERNAL" \
    -e "KAFKA_AUTO_CREATE_TOPICS_ENABLE=false" \
    -e "KAFKA_DELETE_TOPIC_ENABLE=true" \
    -e "KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=100" \
    -e "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1" \
    -e "KAFKA_DEFAULT_REPLICATION_FACTOR=1" \
    -e "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1" \
    -e "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1" \
    -e "KAFKA_MIN_INSYNC_REPLICAS=1" \
    -d \
    confluentinc/cp-kafka:5.5.0

sudo docker exec -it kafka kafka-topics --create \
  --bootstrap-server localhost:9092 \
  --replication-factor 1 \
  --partitions 1 \
  --topic network-traffic
