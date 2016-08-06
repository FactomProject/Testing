#!/bin/bash +x

echo "Moving databases"

function godo {
  echo "Moving databases $1"
  ssh -n $1 'cd .factom/m2; rm -rf \"-database\"; rm -rf local-database; rm TestPeers.json; rm local-peers.json; mv database test-database'
}

godo tda
godo tdb
godo tdc
godo tdd
