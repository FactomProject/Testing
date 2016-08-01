#!/bin/bash +x

echo "Stopping the network."

function stop {
  echo "Stopping $1"
  ssh -n $1 './stop.sh'
}

stop tda
stop tdb
stop tdc
stop tdd
