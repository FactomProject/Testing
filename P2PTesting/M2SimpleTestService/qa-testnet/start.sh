#!/bin/bash +x

echo "Starting the network."

function start {
  ssh -n $1 './start.sh'
}

start tda
start tdb
start tdc
start tdd
