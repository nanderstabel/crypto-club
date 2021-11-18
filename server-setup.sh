#!/bin/bash

IP=`hostname -I | rev | cut -c 2- | rev`

# Clone latest WASP node version
git clone https://github.com/iotaledger/wasp
cd wasp

# Update and upgrade package list
sudo apt-get update
sudo apt-get -y upgrade

# Install go
wget https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz
sudo tar -xvf go1.16.4.linux-amd64.tar.gz
sudo mv go /usr/local
sudo rm go1.16.4.linux-amd64.tar.gz
echo "export GOROOT=/usr/local/go" >> ./.profile
echo "export GOPATH=$HOME/wasp" >> ./.profile
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ./.profile
source ./.profile
unset GOPATH

# Install prerequisites for RocksDB
sudo apt-get install libgflags-dev -y
sudo apt-get install libsnappy-dev -y
sudo apt-get install zlib1g-dev -y
sudo apt-get install libbz2-dev -y
sudo apt-get install liblz4-dev -y
sudo apt-get install libzstd-dev -y

# Install make, g++, npm, json 
sudo apt install make
sudo apt-get install g++ -y
sudo apt install npm -y
npm install -g json

# Compile wasp and wasp-cli binaries
cd wasp
make build

# Replace localhost with public IP address
json -I -f config.json -e "this.webapi.bindAddress='${IP}:9090'"
json -I -f config.json -e "this.dashboard.bindAddress='${IP}:7000'"
json -I -f config.json -e "this.peering.netid='${IP}:4000'"

# Connect to devnet GoShimmer node
json -I -f config.json -e "this.nodeconn.address='${IP}:5000'"
