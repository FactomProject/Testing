#!/bin/bash +x
echo "Deploying Testnet"
echo
echo "This is hardcoded for the test network setup"
echo
echo "This assumes machines are configured, and will update code and configuration, but not touch DB"
echo
echo "Building the current Factomd as a linux binary"

# 1. Build Factomd 
# 2. For each machine:
#   1. Stop factomd on the server
#   2. Upload the conf file for the given machines
#   3. Upload the factomd
#   4. Upload the testnet.sh script to run it
#   5. start the machine.

# update MachineAlias StartFile
function update {
  ssh -n $1 './stop.sh'
  echo "Copying the local factomd to remote machine $1"
    scp /tmp/factomd-p2p-test-build/factomd $1:~/factomd
  echo "Copying scripts"
  scp stop.sh $1:~/
  scp $2 $1:~/start.sh
  scp new_run_header.sh $1:~/
  scp r $1:~/
  echo "Removing previous log file."
  ssh -n $1 'echo \"Config Remote Test Box Reset\" > runlog.txt'
}

# start MachineAlias
function start {
  echo "Starting the server"
  ssh -n -T $1 './start.sh'
}

confPath="~/.factom/m2/factomd.conf"
leaderStart="start-testnet-leader.sh"
followerStart="start-testnet-follower.sh"

./build_factomd.sh
if [ $? -eq 0 ]; then
    echo "was binary updated? Current:`date`"
    ls -G -lh "/tmp/factomd-p2p-test-build/factomd"
    echo "Updating all the servers...."

    echo "Setup the leaders..."
    update m2p2pa $leaderStart
    scp federatedconfigs/leader.conf m2p2pa:$confPath
    start m2p2pa

    update m2p2pb $followerStart
    scp federatedconfigs/0.conf m2p2pb:$confPath
    start m2p2pb

    update m2p2pc $followerStart
    scp federatedconfigs/1.conf m2p2pc:$confPath
    start m2p2pc

    update m2p2pd $followerStart
    scp federatedconfigs/2.conf m2p2pd:$confPath
    start m2p2pd

    update m2p2pe $followerStart
    scp federatedconfigs/3.conf m2p2pe:$confPath
    start m2p2pe

    update m2p2pf $followerStart
    scp federatedconfigs/4.conf m2p2pf:$confPath
    start m2p2pf

    update m2p2pg $followerStart
    scp federatedconfigs/5.conf m2p2pg:$confPath
    start m2p2pg

    update m2p2ph $followerStart
    scp federatedconfigs/6.conf m2p2ph:$confPath
    start m2p2ph

    echo "Load the identities"
    cd loadidentities
    ./run.sh
fi
