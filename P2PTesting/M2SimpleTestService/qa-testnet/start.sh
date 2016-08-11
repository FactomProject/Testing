#!/bin/bash +x

echo "Starting the network."

function godo {
  echo "Starting $1"
  ssh -n $1 './start.sh'
}

godo tda
godo tdb
godo tdc
godo tdd
