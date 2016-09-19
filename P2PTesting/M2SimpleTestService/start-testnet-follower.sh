#!/bin/bash +x

./new_run_header.sh

nohup ./factomd -blktime=120 -prefix="`hostname`-" -netdebug=1 >>runlog.txt 2>&1 &
