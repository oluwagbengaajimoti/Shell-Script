#!/bin/bash

# Update and upgrade Debian-based Linux system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install necessary packages
sudo apt-get install software-properties-common screen -y

# Add Ethereum Personal Package Archive (PPA) and install Ethereum software
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum -y

# Download genesis.json file from Linea documentation site
wget https://docs.linea.build/files/genesis.json

# Create a 100GB file named linea.img
fallocate -l 100G linea.img

# Create an Ext4 filesystem on linea.img
mkfs.ext4 linea.img

# Create a directory named linea_data and mount linea.img to it
mkdir linea_data
sudo mount -o loop linea.img linea_data

# Initialize Ethereum blockchain node using genesis.json
sudo geth --datadir ./linea_data init ./genesis.json

# Start a new screen session named "linea"
screen -S linea -d -m

# Run Ethereum node with specified configurations
screen -S linea -X stuff $'sudo geth \
--datadir linea_data \
--networkid 59144 \
--rpc.allow-unprotected-txs \
--txpool.accountqueue 50000 \
--txpool.globalqueue 50000 \
--txpool.globalslots 50000 \
--txpool.pricelimit 1000000 \
--txpool.pricebump 1 \
--txpool.nolocals \
--http --http.addr \'127.0.0.1\' --http.port 8545 --http.corsdomain \'*\' --http.api \'web3,eth,txpool,net\' --http.vhosts=\'*\' \
--ws --ws.addr \'127.0.0.1\' --ws.port 8546 --ws.origins \'*\' --ws.api \'web3,eth,txpool,net\' \
--bootnodes "enode://ca2f06aa93728e2883ff02b0c2076329e475fe667a48035b4f77711ea41a73cf6cb2ff232804c49538ad77794185d83295b57ddd2be79eefc50a9dd5c48bbb2e@3.23.106.165:30303,enode://eef91d714494a1ceb6e06e5ce96fe5d7d25d3701b2d2e68c042b33d5fa0e4bf134116e06947b3f40b0f22db08f104504dd2e5c790d8bcbb6bfb1b7f4f85313ec@3.133.179.213:30303,enode://cfd472842582c422c7c98b0f2d04c6bf21d1afb2c767f72b032f7ea89c03a7abdaf4855b7cb2dc9ae7509836064ba8d817572cf7421ba106ac87857836fa1d1b@3.145.12.13:30303" \
--syncmode full \
--metrics \
--verbosity 3\n'

echo "Node deployed. Detach from the screen session using CTRL+A+D."
echo "To reattach, use command: screen -r linea"
