#!/bin/bash +x
echo "Deploying DEVELOPER Testnet"
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
  ../update-test-box.sh $1 $2
}

# start MachineAlias
function start {
  echo "Starting the server"
  ssh -n -T $1 './start.sh'
}

confPath="~/.factom/m2/factomd.conf"
leaderStart="start-testnet-leader.sh"
followerStart="start-testnet-follower.sh"

TMPDIR="/tmp/factomd-p2p-test-build"
mkdir $TMPDIR
cd "$GOPATH/src/github.com/FactomProject/factomd"
echo "Building linux factomd and putting it in $TMPDIR"
CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o "$TMPDIR/factomd"
if [ $? -eq 0 ]; then
    echo "was binary updated? Current:`date`"
    ls -G -lh "/tmp/factomd-p2p-test-build/factomd"
    echo "Updating all the servers...."

    echo "Setup the leaders..."
    update m2p2pa $leaderStart
    scp configs/leader.conf m2p2pa:$confPath
    start m2p2pa

    update m2p2pb $followerStart
    scp configs/0.conf m2p2pb:$confPath
    start m2p2pb

    update m2p2pc $followerStart
    scp configs/1.conf m2p2pc:$confPath
    start m2p2pc

    update m2p2pd $followerStart
    scp configs/2.conf m2p2pd:$confPath
    start m2p2pd

    update m2p2pe $followerStart
    scp configs/3.conf m2p2pe:$confPath
    start m2p2pe

    update m2p2pf $followerStart
    scp configs/4.conf m2p2pf:$confPath
    start m2p2pf

    update m2p2pg $followerStart
    scp configs/5.conf m2p2pg:$confPath
    start m2p2pg

    update m2p2ph $followerStart
    scp configs/6.conf m2p2ph:$confPath
    start m2p2ph

    echo "*****************************"
    echo "*****************************"
    echo "*****************************"
    echo "*****************************"

    echo "Sleep before loading identities"
    sleep 250
    echo "Load the identities"
    cd loadidentities

    HOST=13.84.217.234:8088

    ### Make identities eligible to be promoted
    #                #Idents   Host     
    sh loadidentities.sh 8 $HOST

    # BlkTime(s)
    echo "Waiting for next block... "
    sleep 100s

    # Promote IDs 0 - 3 to Federated
    sh makeXfeds.sh 0 3 $HOST

    # Promote IDs 4-7 to Audit
    sh makeXauds.sh 4 7 $HOST
    echo "#### Network Should be UP #####"
fi
