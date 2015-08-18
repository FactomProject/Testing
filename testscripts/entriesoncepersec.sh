#!/bin/bash

rand=$(openssl rand -base64 8)

chainid=$(echo testing | factom-cli mkchain -e $rand -e test -e 1 app | awk -F': ' '{print $2}')

echo ChainID $chainid >>testchainid

for ((i=0; i < 600; i++)); do
        echo $i | factom-cli put -c $chainid -e $i app &
        sleep 1
done
