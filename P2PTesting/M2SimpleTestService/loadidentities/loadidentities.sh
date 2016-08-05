#!/usr/bin/env bash
TOTAL=$1
HOST=$2

# addtoblockchain localhost:8080 16
echo "Adding identites to blockchain"
addtoblockchain $HOST $TOTAL 10000 false
