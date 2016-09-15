#!/bin/bash +x

nohup ./factomd -networkPort=8110 -network="LOCAL" -blktime=60 -netdebug=1 -exclusive=true > /vagrant/output/leader.out 2>&1 &
