#!/usr/bin/env bash
COUNTER=$1
HOST=$3
echo "Promoting Audit Servers..."
while [  $COUNTER -lt $2  ]; do
	bash send.sh $COUNTER a a $HOST
	let COUNTER=COUNTER+1 
	sleep 1s
done