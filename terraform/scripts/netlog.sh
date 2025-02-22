#!/bin/bash
KAFKA_IP=$1
sudo docker run --name netlog \
    --hostname netlog \
    --network host \
    --entrypoint bash \
    -d \
    recedivies09/spoofy:latest -c "/wait-for-it.sh $KAFKA_IP:19092 -- /usr/local/bin/spoofy -i eth0 --live --sender kafka --broker $KAFKA_IP:19092 --topic network-traffic"
