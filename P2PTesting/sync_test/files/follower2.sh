#!/bin/bash +x


nohup ./factomd -prefix="follower2-" -peers="10.0.99.3:8110" -networkPort=8110 -network="LOCAL" -blktime=60 -netdebug=1 > /vagrant/output/follower2.out 2>&1 &
