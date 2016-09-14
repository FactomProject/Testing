#!/bin/bash +x


nohup ./factomd -prefix="follower-" -peers="10.0.99.3:8110" -networkPort=8110 -network="LOCAL" -blktime=60 -netdebug=1 -exclusive=true > /vagrant/output/follower.out 2>&1 &
