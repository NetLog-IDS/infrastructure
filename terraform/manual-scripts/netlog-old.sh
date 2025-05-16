# Install dependencies
sudo apt-get install python3-pip tcpreplay
pip3 install gdown # /home/ubuntu/.local/bin/gdown


cd /tmp

# Download the test files that is stored in Google Drive
# DOS Only
/home/ubuntu/.local/bin/gdown 1o264oRpwkKA71hnpGbKQH37jRcb30AD5

# PortScan
/home/ubuntu/.local/bin/gdown 1DPJvuuiXvxBt1AX9P55BThDkJ9ISk5sv

# Command to run the container for Netlog
# You can change the interface name from <lo> to any other interface name on -i
# Change broker IP on --broker to Kafka virtual machine's IP
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
      --broker 54.81.225.156:19092 \
      --topic network-traffic"

# Replay the .pcap test files in its original speed using tcpreplay-edit on <lo> interface. You can change the interface name from <lo> to any other interface name on -i
# --mtu-trunc is used to truncate the MTU size of the packets to the size limit of the interface
# For DOS
sudo tcpreplay-edit -i lo --mtu-trunc /tmp/dos_test.pcap

# For PortScan
sudo tcpreplay-edit -i lo --mtu-trunc /tmp/port_scan_test.pcap
