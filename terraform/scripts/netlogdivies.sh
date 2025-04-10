#!/bin/bash
sudo docker run --name netlogdivies \
    --hostname netlogdivies \
    -v /mnt/extra/datasets/processed/friday_test.pcap:/test.pcap \
    netlogdivies \
    ./netlogdivies \
    -i /test.pcap \
    -f "tcp or udp" \
    --sender kafka \
    --broker $KAFKA_IP:9092 \
    --topic network-traffic \
    --mode ordered
