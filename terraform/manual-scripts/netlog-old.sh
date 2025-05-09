sudo apt-get install python3-pip
pip3 install gdown # /home/ubuntu/.local/bin/gdown

# exit then ssh again
cd /tmp
# /home/ubuntu/.local/bin/gdown --id 1ywI9r1UsyFpGVV_aHzLk-Z3OL-UnFBja
# /home/ubuntu/.local/bin/gdown --id 1MXcaagodK8v8MfGkIlj3Iiz8yCONh06L
/home/ubuntu/.local/bin/gdown --id 1eDadFhQntu-3ED2DKtCwP4mnSuaB_zBT

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
  --rm \
  --name netlog \
  --hostname netlog \
  --network host \
  --entrypoint bash \
  recedivies09/netlog-old:latest \
  -c "/usr/local/bin/spoofy \
      -i <Network_Inteface> \
      --live \
      -f 'tcp or udp' \
      --sender kafka \
      --broker 13.217.149.8:19092 \
      --topic network-traffic"
