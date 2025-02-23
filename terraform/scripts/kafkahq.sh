#!/bin/bash
KAFKA_IP=$1
sudo docker run -d \
  --name kafkahq \
  --hostname kafkahq \
  -p 8082:8080 \
  -e KAFKAHQ_CONFIGURATION="kafkahq:
          connections:
            docker-kafka-server:
              properties:
                bootstrap.servers: \"$KAFKA_IP:19092\"" \
  tchiotludo/kafkahq
