#!/bin/bash +x

./new_run_header.sh

nohup ./factomd -network="TEST" -peers="10.5.0.4:8109 10.5.0.5:8109 10.5.0.6:8109 10.5.0.7:8109 10.5.0.8:8109 10.5.0.9:8109 10.5.0.10:8109 10.5.0.11:8109" -netdebug=3 >>runlog.txt 2>&1 &
