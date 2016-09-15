#!/usr/bin/env bash

echo "This sets up vagrant boxes, builds factomd, installs it, and then runs it."

echo "clean up output from previous run.  Deleting all files named *.out in output directory"
rm output/*.out

CWD=`pwd`
DEST="$CWD/files/factomd"
echo "changing directory to factomd"

cd "$GOPATH/src/github.com/FactomProject/factomd"

echo "Building linux factomd and putting it in $DEST"
CGO_ENABLED=0 GOOS=linux go build -ldflags "-X github.com/FactomProject/factomd/engine.Build=`git rev-parse HEAD`" -installsuffix cgo -o $DEST
if [ $? -eq 0 ]; then
  echo "was filesary updated? Current:`date`"
  ls -G -lh $DEST

  echo "changing directory to back to Vagrant Root ( $CWD )"
  cd $CWD

  echo "Bounce the boxes to make sure they are in a good state."
  vagrant halt
  sleep 2
  vagrant up
  
  echo "Leader Timestamp:"
  ssh leader "date"
  echo "Follower Timestamp:"
  ssh follower "date"
  echo "Follower2 Timestamp:"
  ssh follower2 "date"
  
  echo "About to kill processes"
  ssh -n leader "pkill factomd; pkill factom-walletd; pkill factom-cli"
  ssh -n follower "pkill factomd; pkill factom-walletd; pkill factom-cli"
  ssh -n follower2 "pkill factomd; pkill factom-walletd; pkill factom-cli"
  
  echo "About to delete .factom"
  ssh -n leader "rm -rf ~/.factom"
  ssh -n follower "rm -rf ~/.factom"
  ssh -n follower2 "rm -rf ~/.factom"

  echo "About to create .factom"
  ssh -n leader "mkdir ~/.factom"
  ssh -n follower "mkdir ~/.factom"
  ssh -n follower2 "mkdir ~/.factom"
  
  echo "About to create .factom/m2"
  ssh -n leader "mkdir ~/.factom/m2"
  ssh -n follower "mkdir ~/.factom/m2"
  ssh -n follower2 "mkdir ~/.factom/m2"


  echo "Copying factomd.conf to ~/.factom/m2"
  ssh -n leader "cp /vagrant/files/factomd.conf ~/.factom/m2"
  ssh -n follower "cp /vagrant/files/factomd.conf ~/.factom/m2"
  ssh -n follower2 "cp /vagrant/files/factomd.conf ~/.factom/m2"

  echo "Start the leader"
  ssh -n leader "cd /vagrant/files/ && ./leader.sh" 

  sleep 10
  echo "Start the wallet"
  ssh -n leader "cd /vagrant/files/ && ./wallet.sh" 

  echo "Sleep while waiting for the leader to make blocks."
  sleep 300

  echo "Sleep while waiting for the leader to make blocks."
  sleep 300

  # echo "Turn off latency on the follower"
  # ssh -n follower "sudo tc qdisc del dev eth0 root"
  # ssh -n follower "sudo tc qdisc del dev eth1 root"

  echo "Turn on latency on the follower"
  # Hit both network interfaces, because the NAT and private/host only seem to change between create/destroy.
  ssh -n follower "sudo tc qdisc add dev eth1 root netem delay 400ms"
  ssh -n follower2 "sudo tc qdisc add dev eth0 root netem delay 400ms"

  echo "Follower to leader Ping:"
  ssh -n follower "ping -c 3 10.0.99.3"

  echo "Leader to follower Ping:"
  ssh -n leader "ping -c 3 10.0.99.2"

  echo "Start the follower"
  ssh -n follower "cd /vagrant/files/ && ./follower.sh"
  ssh -n follower2 "cd /vagrant/files/ && ./follower2.sh"

  echo "Start the wallet"
  ssh -n follower "cd /vagrant/files/ && ./wallet.sh" 

  echo "Add entries"
  ssh -n follower "cd /vagrant/files/ && ./entries.sh &"  

  echo "Verify entries were entered:"

  # ssh -n follower "/vagrant/files/factom-cli listaddresses"
  ssh -n leader "/vagrant/files/factom-cli listaddresses"
  ssh -n leader "/vagrant/files/factom-cli get allentries b69469af5a875cfd50786827e92171a84232bd7a198fa29234ac931e40a342c3"
  ssh -n follower "/vagrant/files/factom-cli get allentries b69469af5a875cfd50786827e92171a84232bd7a198fa29234ac931e40a342c3"
  ssh -n follower2 "/vagrant/files/factom-cli get allentries b69469af5a875cfd50786827e92171a84232bd7a198fa29234ac931e40a342c3"


  echo "Block Heights. CTRL-C to quit."
 for i in $(seq 100); do
    date
    L="$(ssh -n leader "/vagrant/files/factom-cli get height")"
    F="$(ssh -n follower "/vagrant/files/factom-cli get height")"
    F2="$(ssh -n follower2 "/vagrant/files/factom-cli get height")"
    echo "Leader: ${L} Follower: ${F} Follower2: ${F2}"
    sleep 2
  done
fi

# Simulate 1 second delay with 25% packet loss:
# sudo tc qdisc add dev eth0 root netem delay 1000ms loss 25%

# to view the current modifications and status:
# sudo tc -s qdisc

# to remove the modifications:
# sudo tc qdisc del dev eth0 root


# to simulate low bandwidth:
# sudo tc qdisc add dev eth0 root handle 1:0 netem delay 1000ms
# sudo tc qdisc add dev eth0 parent 1:1 handle 10: tbf rate 4096kbit buffer 1600 limit 3000
# tc -s qdisc ls dev eth0
