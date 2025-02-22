#!/bin/bash
sudo docker run --name zookeeper \
    --hostname zookeeper \
    -p 2181:2181 \
    -e ZOOKEEPER_CLIENT_PORT=2181 \
    -e ZOOKEEPER_TICK_TIME=2000 \
    -d \
    confluentinc/cp-zookeeper:5.5.0
