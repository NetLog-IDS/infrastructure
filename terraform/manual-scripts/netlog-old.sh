sudo apt-get install python3-pip tcpreplay
pip3 install gdown # /home/ubuntu/.local/bin/gdown

# exit then ssh again
cd /tmp
# DOS Only
/home/ubuntu/.local/bin/gdown 1o264oRpwkKA71hnpGbKQH37jRcb30AD5

# PortScan
/home/ubuntu/.local/bin/gdown 1DPJvuuiXvxBt1AX9P55BThDkJ9ISk5sv

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
      --broker 3.87.99.18:19092 \
      --topic network-traffic"

# For DOS
sudo tcpreplay-edit -i lo --mtu-trunc /tmp/dos_test.pcap

# For PortScan
sudo tcpreplay-edit -i lo --mtu-trunc /tmp/port_scan_test.pcap
