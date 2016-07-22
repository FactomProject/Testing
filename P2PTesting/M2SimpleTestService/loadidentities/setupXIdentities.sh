#!/usr/bin/env bash
# Load X identies, where X is the first input

### Make identities elibible to be promoted
#                #Idents   Host    
sh loadidentities.sh $1 13.84.217.234:8088
### Example load
### - Makes 20 identies eligible for promotion
# sh loadidentities.sh 20 13.84.217.234:8088