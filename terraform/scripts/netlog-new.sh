#!/bin/bash
KAFKA_IP=$1

sudo docker pull recedivies09/netlog-new

sudo apt-get install python3-pip
pip3 install gdown # /home/ubuntu/.local/bin/gdown

# exit then ssh again
cd /tmp
/home/ubuntu/.local/bin/gdown --id 1eDadFhQntu-3ED2DKtCwP4mnSuaB_zBT

# DOS Only
/home/ubuntu/.local/bin/gdown --id 1o264oRpwkKA71hnpGbKQH37jRcb30AD5

# PortScan
/home/ubuntu/.local/bin/gdown --id 1DPJvuuiXvxBt1AX9P55BThDkJ9ISk5sv

sudo apt install tcpreplay

while ! nc -z $KAFKA_IP 19092; do sleep 5; echo 'Waiting for Kafka...'; done
