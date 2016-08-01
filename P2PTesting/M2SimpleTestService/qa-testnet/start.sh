#!/bin/bash +x

echo "Starting the network."

function start {
  echo "Starting $1"
  ssh -n $1 './start.sh'
}

start tda
start tdb
start tdc
start tdd
