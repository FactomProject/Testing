#!/bin/bash +x

echo "Stopping the network."

function update {
  ssh -n $1 './stop.sh'
}

stop tda
stop tdb
stop tdc
stop tdd
