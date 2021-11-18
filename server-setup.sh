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
. ~/.profile
echo "export GOPATH=\$HOME/wasp" >> ~/.profile
. ~/.profile
echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH" >> ~/.profile
. ~/.profile
unset GOPATH

# # Install prerequisites for RocksDB
# sudo apt-get install libgflags-dev -y
# sudo apt-get install libsnappy-dev -y
# sudo apt-get install zlib1g-dev -y
# sudo apt-get install libbz2-dev -y
# sudo apt-get install liblz4-dev -y
# sudo apt-get install libzstd-dev -y

# # Install make, g++, npm, json, moreutils, jq
# sudo apt install make
# sudo apt-get install g++ -y
# sudo apt install moreutils -y
# sudo apt install jq -y

# # Compile wasp and wasp-cli binaries
# cd wasp
# make build

# # Replace localhost with public IP address
# jq '.webapi.bindAddress = "'${IP}':9090"' config.json|sponge config.json
# jq '.dashboard.bindAddress = "'${IP}':7000"' config.json|sponge config.json
# jq '.peering.netid = "'${IP}':4000"' config.json|sponge config.json

# # Connect to devnet GoShimmer node
# jq '.nodeconn.address = "goshimmer.sc.iota.org:5000"' config.json|sponge config.json
