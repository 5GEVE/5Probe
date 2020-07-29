#!/bin/bash

# Execute this script once

# Install dependencies
sudo apt-get install libpcap0.8
sudo apt-get install libpthread-stubs0-dev

# Setting for sniffing
sudo groupadd pcap
sudo usermod -a -G pcap $USER
sudo chgrp pcap probe
sudo chmod 750 probe
sudo setcap cap_net_raw,cap_net_admin=eip probe
