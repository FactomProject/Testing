#!/bin/bash

rand=$(openssl rand -base64 8)

chainid=$(echo testing | factom-cli mkchain -e $rand -e test -e 1 app | awk -F': ' '{print $2}')

echo ChainID $chainid >>testchainid

for ((i=0; i < 100; i++)); do
    for ((j=0; j < 1000; j++)); do
        echo $i $j | factom-cli put -c $chainid -e $i -e $j app &
    done
    sleep 1
done

echo entries have been written to chain $chainid