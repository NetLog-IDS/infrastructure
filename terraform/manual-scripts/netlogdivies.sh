sudo apt-get install python3-pip
pip3 install gdown # /home/ubuntu/.local/bin/gdown

# exit then ssh again
cd /tmp
/home/ubuntu/.local/bin/gdown --id 1ywI9r1UsyFpGVV_aHzLk-Z3OL-UnFBja
/home/ubuntu/.local/bin/gdown --id 1MXcaagodK8v8MfGkIlj3Iiz8yCONh06L

# change /tmp/friday_test.pcap to file you want to use
sudo docker run --name netlogdivies \
    --hostname netlogdivies \
    -v /tmp/friday_test.pcap:/test.pcap \
    recedivies09/netlogdivies \
    ./netlogdivies \
    -i /test.pcap \
    -f "tcp or udp" \
    --sender kafka \
    --broker 172.31.32.165:19092 \
    --topic network-traffic \
    --mode ordered
