#!/bin/bash +x

./new_run_header.sh

nohup ./factomd -blktime=60 -netdebug=2 >>runlog.txt 2>&1 &
