#!/bin/bash +x

nohup ./factomd -peers="10.0.99.2:8110 10.0.99.4:8110" -networkPort=8110 -network="LOCAL" -blktime=60 -netdebug=1 > /vagrant/output/leader.out 2>&1 &
