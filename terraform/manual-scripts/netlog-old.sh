sudo apt-get install python3-pip
pip3 install gdown # /home/ubuntu/.local/bin/gdown

# exit then ssh again
cd /tmp
# DOS Only
/home/ubuntu/.local/bin/gdown 1o264oRpwkKA71hnpGbKQH37jRcb30AD5

# PortScan
/home/ubuntu/.local/bin/gdown 1DPJvuuiXvxBt1AX9P55BThDkJ9ISk5sv

# change /tmp/friday_test.pcap to file you want to use
# Change broker IP on --broker to Kafka virtual machine's IP
sudo docker run \
  --rm \
  --name netlog \
  --hostname netlog \
  -v /tmp/test.pcap:/test.pcap \
  --network host \
  --entrypoint bash \
  recedivies09/netlog-old:latest \
  -c "/usr/local/bin/spoofy \
      -i /test.pcap \
      -f 'tcp or udp' \
      --sender kafka \
      --broker 13.217.59.217:19092 \
      --topic network-traffic"

# Manual
sudo docker run \
  -it \
  --rm \
  --name netlog \
  --hostname netlog \
  --network host \
  --entrypoint bash \
  recedivies09/netlog-old:latest \
  -c "/usr/local/bin/spoofy \
      -i eth0 \
      --live \
      -f 'tcp or udp' \
      --sender kafka \
      --broker 13.217.149.8:19092 \
      --topic network-traffic"
