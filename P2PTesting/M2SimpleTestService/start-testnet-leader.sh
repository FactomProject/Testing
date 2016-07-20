#!/bin/bash +x

./new_run_header.sh

nohup ./factomd -netdebug=1 >>runlog.txt 2>&1 &
