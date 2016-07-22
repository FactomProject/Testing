#!/usr/bin/env bash
COUNTER=$1
HOST=$3
echo "Promoting Federated Servers..."
while [  $COUNTER -lt $2  ]; do
	sh send.sh $COUNTER f a $HOST
	let COUNTER=COUNTER+1 
	sleep 1s
done