#!/bin/bash +x

echo "Stopping the network."

function godo {
  echo "Stopping $1"
  ssh -n $1 './stop.sh'
}

godo m2p2pa
godo m2p2pb
godo m2p2pc
godo m2p2pd
godo m2p2pe
godo m2p2pf
godo m2p2pg
godo m2p2ph
