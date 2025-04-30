sudo apt-get install python3-pip
pip3 install gdown # /home/ubuntu/.local/bin/gdown

# exit then ssh again
cd /tmp
/home/ubuntu/.local/bin/gdown --id 1ywI9r1UsyFpGVV_aHzLk-Z3OL-UnFBja
/home/ubuntu/.local/bin/gdown --id 1MXcaagodK8v8MfGkIlj3Iiz8yCONh06L

# change /tmp/friday_test.pcap to file you want to use
# Change broker IP on --broker to Kafka virtual machine's IP
sudo docker run \
  --rm \
  --name netlog \
  --hostname netlog \
  -v /tmp/friday_test.pcap:/test.pcap \
  --network host \
  --entrypoint bash \
  recedivies09/spoofy:latest \
  -c "/usr/local/bin/spoofy \
      -i /test.pcap \
      -f 'tcp or udp' \
      --sender kafka \
      --broker 13.217.149.8:19092 \
      --topic network-traffic \
      --replay"
