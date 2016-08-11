#!/bin/bash +x

echo "Stopping the network."

function godo {
  echo "Stopping $1"
  ssh -n $1 './stop.sh'
}

godo tda
godo tdb
godo tdc
godo tdd
