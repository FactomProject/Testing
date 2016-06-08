#!/bin/bash
echo "Stopping factomd on $1 before updating."
ssh -n $1 './stop.sh'
echo "Copying the local factomd to remote machine $1"
scp /tmp/factomd-p2p-test-build/factomd $1:~/factomd
echo "Copying scripts"
scp leader.sh $1:~/
scp follower.sh $1:~/
scp stop.sh $1:~/
echo "Removing previous log file."
ssh -n $1 'echo \"Config Remote Test Box Reset\" > runlog.txt'
scp new_run_header.sh $1:~/
scp r $1:~/