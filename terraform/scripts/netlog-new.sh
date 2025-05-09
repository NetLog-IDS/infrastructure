#!/bin/bash
KAFKA_IP=$1

sudo docker pull recedivies09/netlog-new
while ! nc -z $KAFKA_IP 19092; do sleep 5; echo 'Waiting for Kafka...'; done
