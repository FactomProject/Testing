#!/bin/bash +x

echo "Stopping the network."

function stop {
  echo "Stopping $1"
  ssh -n $1 './stop.sh'
}


stop m2p2pa
stop m2p2pb
stop m2p2pc
stop m2p2pd
stop m2p2pe
stop m2p2pf
stop m2p2pg
stop m2p2ph
