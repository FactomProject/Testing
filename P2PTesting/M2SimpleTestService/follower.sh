#!/bin/bash +x

./new_run_header.sh
nohup ./factomd -count=5 -p2pPort="8108" \
-peers="10.5.0.4:8108 10.5.0.5:8108 10.5.0.6:8108 10.5.0.7:8108 10.5.0.8:8108 10.5.0.9:8108 10.5.0.10:8108 10.5.0.11:8108" \
 -netdebug=1 -prefix="`hostname`-" >>runlog.txt 2>&1 &

