#!/bin/bash

factom-cli generateaddress fct dummy0
factom-cli generateaddress fct dummy1
factom-cli generateaddress fct dummy2
factom-cli generateaddress fct dummy3
factom-cli generateaddress fct dummy4
factom-cli generateaddress fct dummy5
factom-cli generateaddress fct dummy6
factom-cli generateaddress fct dummy7
factom-cli generateaddress fct dummy8
factom-cli generateaddress fct dummy9

rand=$(openssl rand -base64 8)

echo "Create a transaction and fund the app Entry Credit Address"

factom-cli newtransaction a
factom-cli newaddress ec app
factom-cli addinput a dummy0 1000
factom-cli addecoutput a app 1000
factom-cli addfee a dummy0
factom-cli sign a
factom-cli submit a

sleep 60s

factom-cli balances

chainid=$(echo testing | factom-cli mkchain -e $rand -e test -e 1 app | awk -F': ' '{print $2}')

echo ChainID $chainid >>testchainid

for ((i=0; i < 600000; i++)); do
        echo $i | factom-cli put -c $chainid -e $i app &
        echo $i " "
        sleep 1s
done
