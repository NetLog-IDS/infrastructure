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

# change /tmp/friday_test.pcap to file you want to use
# Change broker IP on --broker to Kafka virtual machine's IP

# Manual
sudo docker run \
  --rm \
  --name netlog \
  --hostname netlog \
  --network host \
  --entrypoint bash \
  recedivies09/spoofy:latest \
  -c "/usr/local/bin/spoofy \
      -i lo \
      --live \
      -f 'tcp or udp' \
      --sender kafka \
      --broker 18.234.180.181:19092 \
      --topic network-traffic"

sudo tcpreplay-edit -i lo --mtu-trunc test.pcap
