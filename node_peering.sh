#!/bin/bash

PEER_PUBKEY=$2
PEER_NET_ID=$3
PEER_IP=${PEER_NET_ID%:*}

# Add peer node to wasp-cli.json file
./wasp-cli set wasp.$1.api $PEER_IP:9090
./wasp-cli set wasp.$1.nanomsg $PEER_IP:5550
./wasp-cli set wasp.$1.peering $PEER_IP:4000

# Add peer IP address to whitelist
jq '.webapi.adminWhitelist += ["'$PEER_ID'"]' config.json|sponge config.json

# Trust peer node
./wasp-cli peering trust $2 $3
