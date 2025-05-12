sudo apt-get install python3-pip
pip3 install gdown # /home/ubuntu/.local/bin/gdown

# exit then ssh again
cd /tmp
# DOS Only
/home/ubuntu/.local/bin/gdown 1o264oRpwkKA71hnpGbKQH37jRcb30AD5

# PortScan
/home/ubuntu/.local/bin/gdown 1DPJvuuiXvxBt1AX9P55BThDkJ9ISk5sv

sudo apt install tcpreplay

# change /tmp/friday_test.pcap to file you want to use
# Change broker IP on --broker to Kafka virtual machine's IP
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
      -i lo \
      --live \
      -f 'tcp or udp' \
      --sender kafka \
      --broker 98.80.78.28:19092 \
      --topic network-traffic"

sudo tcpreplay-edit -i lo --mtu-trunc /tmp/dos_test.pcap
