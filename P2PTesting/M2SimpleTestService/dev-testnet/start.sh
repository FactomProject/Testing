#!/bin/bash +x

echo "Starting the network."

function start {
   echo "Starting $1"
 ssh -n $1 './start.sh'
}


start m2p2pa
start m2p2pb
start m2p2pc
start m2p2pd
start m2p2pe
start m2p2pf
start m2p2pg
start m2p2ph
