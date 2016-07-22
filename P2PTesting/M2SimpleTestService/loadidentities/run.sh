#!/usr/bin/env bash
HOST=localhost:8088


### Make identities elibible to be promoted
#                #Idents   Host     
sh loadidentities.sh 8 $HOST

# BlkTime(s)
echo "Waiting for next block... "
sleep 2s

# Promote IDs 0 - 3 to Federated
sh makeXfeds.sh 0 3 $HOST

# Promote IDs 4-7 to Audit
sh makeXauds.sh 4 7 $HOST