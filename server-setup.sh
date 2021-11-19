#!/bin/bash

IP=`hostname -I | cut -d ' ' -f1`

# Clone latest WASP node version
git clone https://github.com/iotaledger/wasp

# Update and upgrade package list
sudo apt-get update
sudo apt-get -y upgrade

# Install go
wget https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz
sudo tar -xvf go1.16.4.linux-amd64.tar.gz
sudo mv go /usr/local
sudo rm go1.16.4.linux-amd64.tar.gz
echo "export GOROOT=/usr/local/go" >> ~/.profile
echo "export GOPATH=\$HOME/wasp" >> ~/.profile
echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH" >> ~/.profile
source ~/.profile
unset GOPATH

# Install prerequisites for RocksDB
sudo apt-get install libgflags-dev -y
sudo apt-get install libsnappy-dev -y
sudo apt-get install zlib1g-dev -y
sudo apt-get install libbz2-dev -y
sudo apt-get install liblz4-dev -y
sudo apt-get install libzstd-dev -y

# Install make, g++, npm, json, moreutils, jq
sudo apt install make
sudo apt-get install g++ -y
sudo apt install moreutils -y
sudo apt install jq -y

# Compile wasp and wasp-cli binaries
cd wasp
make build

# Increase maximum buffer size
sudo sysctl -w net.core.rmem_max=2500000

# Replace localhost with public IP address
jq '.webapi.bindAddress = "'${IP}':9090"' config.json|sponge config.json
jq '.dashboard.bindAddress = "'${IP}':7000"' config.json|sponge config.json
jq '.peering.netid = "'${IP}':4000"' config.json|sponge config.json

# Connect to devnet GoShimmer node and add whitelist
jq '.nodeconn.address = "goshimmer.sc.iota.org:5000"' config.json|sponge config.json
jq '.webapi.adminWhitelist = ["'${IP}'"]' config.json|sponge config.json

# Initialize wasp-cli and request funds
./wasp-cli init
./wasp-cli request-funds

# Configure wasp-cli.json file
./wasp-cli set goshimmer.api https://api.goshimmer.sc.iota.org

./wasp-cli set wasp.0.api ${IP}:9090
./wasp-cli set wasp.0.nanomsg ${IP}:5550
./wasp-cli set wasp.0.peering ${IP}:4000

# Run WASP node
./wasp --logger.level="warn"
