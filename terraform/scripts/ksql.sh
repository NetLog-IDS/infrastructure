#!/bin/bash
KAFKA_IP=$1
KAFKA_HQ_IP=$2

sudo docker pull confluentinc/cp-ksqldb-server:7.8.1

while [ ! -f /tmp/queries.sql ]; do sleep 10; done
while ! nc -z $KAFKA_IP 19092; do sleep 5; echo 'Waiting for Kafka...'; done
while [[ "$(curl -s -o /dev/null -w '%{http_code}' http://$KAFKA_HQ_IP:8082/docker-kafka-server/topic/network-traffic)" != "200" ]]; do sleep 5; echo 'Waiting for Kafka topic...'; done

sudo docker run -d \
    --name ksql-server \
    --hostname ksql-server \
    -p 8088:8088 \
    -v /tmp/queries.sql:/queries.sql \
    -e KSQL_CONFIG_DIR="/etc/ksql" \
    -e KSQL_BOOTSTRAP_SERVERS="$KAFKA_IP:19092" \
    -e KSQL_HOST_NAME="ksql-server" \
    -e KSQL_APPLICATION_ID="ksql-ids" \
    -e KSQL_LISTENERS="http://0.0.0.0:8088" \
    -e KSQL_PRODUCER_INTERCEPTOR_CLASSES="io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor" \
    -e KSQL_CONSUMER_INTERCEPTOR_CLASSES="io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor" \
    -e KSQL_KSQL_SERVER_UI_ENABLED="false" \
    -e KSQL_KSQL_QUERIES_FILE="/queries.sql" \
    confluentinc/cp-ksqldb-server:7.8.1
