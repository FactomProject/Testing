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
  echo "#####"; echo; echo " $1"; echo; echo "#####"
  ssh -n $1 './stop.sh'
  ssh -n $1 'echo \"Config Remote Test Box Reset\" > runlog.txt'
  ssh -n $1 'rm message_log.csv; touch message_log.csv'
  scp /tmp/factomd-p2p-test-build/factomd $1:~/factomd
  echo "Copying scripts"
  scp ../stop.sh $1:~/
  scp $2 $1:~/start.sh
  scp ../new_run_header.sh $1:~/
  scp ../r $1:~/
  echo "Removing previous log file."
  ssh -n $1 'echo \"Config Remote Test Box Reset\" > runlog.txt'
}

# start MachineAlias
function start {
  echo "Starting the server"
  ssh -n -T $1 './start.sh'
}

CWD=`pwd`

confPath="~/.factom/m2/factomd.conf"
leaderStart="../start-testnet-leader.sh"
followerStart="../start-testnet-follower.sh"

TMPDIR="/tmp/factomd-p2p-test-build"
mkdir $TMPDIR
cd "$GOPATH/src/github.com/FactomProject/factomd"
echo "Building linux factomd and putting it in $TMPDIR"
CGO_ENABLED=0 GOOS=linux go build -ldflags "-X github.com/FactomProject/factomd/engine.Build=`git rev-parse HEAD`" -installsuffix cgo -o "$TMPDIR/factomd"
if [ $? -eq 0 ]; then
    echo "was binary updated? Current:`date`"
    ls -G -lh "/tmp/factomd-p2p-test-build/factomd"
    echo "Updating all the servers...."
    cd $CWD
    echo "Setup the leaders..."
    update m2p2pa $leaderStart
    scp configs/leader.conf m2p2pa:$confPath

    update m2p2pb $followerStart
    scp configs/0.conf m2p2pb:$confPath

    update m2p2pc $followerStart
    scp configs/1.conf m2p2pc:$confPath

    update m2p2pd $followerStart
    scp configs/2.conf m2p2pd:$confPath

    update m2p2pe $followerStart
    scp configs/3.conf m2p2pe:$confPath

    update m2p2pf $followerStart
    scp configs/4.conf m2p2pf:$confPath

    update m2p2pg $followerStart
    scp configs/5.conf m2p2pg:$confPath

    update m2p2ph $followerStart
    scp configs/6.conf m2p2ph:$confPath

    ./start.sh

    echo "*****************************"
    echo "*****************************"
    echo "*****************************"
    echo "*****************************"

    echo "Sleep before loading identities"
    sleep 120
    echo "Load the identities"
    cd ../loadidentities

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
