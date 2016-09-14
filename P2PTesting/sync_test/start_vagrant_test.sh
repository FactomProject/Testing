#!/usr/bin/env bash

echo "This sets up vagrant boxes, builds factomd, installs it, and then runs it."

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

  echo "About to delete .factom"
  ssh -n leader "pkill factomdl; pkill factom-walletd; pkill factom-cli"
  ssh -n follower "pkill factomdl; pkill factom-walletd; pkill factom-cli"

  echo "About to delete .factom"
  ssh -n leader "rm -rf ~/.factom"
  ssh -n follower "rm -rf ~/.factom"

  echo "About to create .factom"
  ssh -n leader "mkdir ~/.factom"
  ssh -n follower "mkdir ~/.factom"

  echo "About to create .factom/m2"
  ssh -n leader "mkdir ~/.factom/m2"
  ssh -n follower "mkdir ~/.factom/m2"

  echo "Copying factomd.conf to ~/.factom/m2"
  ssh -n leader "cp /vagrant/files/factomd.conf ~/.factom/m2"
  ssh -n follower "cp /vagrant/files/factomd.conf ~/.factom/m2"

  echo "Start the leader"
  ssh -n leader "cd /vagrant/files/ && ./leader.sh" 

  sleep 10
  echo "Start the wallet"
  ssh -n leader "cd /vagrant/files/ && ./wallet.sh" 

  echo "Sleep while waiting for the leader to make blocks."
  sleep 120

  echo "Add entries"
  ssh -n leader "cd /vagrant/files/ && ./entries.sh &"  

  echo "Sleep while waiting for the leader to make blocks."
  sleep 100

  # echo "Turn off latency on the follower"
  # sudo -n follower "sudo tc qdisc del dev eth0 root"

  echo "Turn on latency on the follower"
  ssh -n follower "sudo tc qdisc add dev eth0 root netem delay 400ms"

  echo "Start the follower"
  ssh -n follower "cd /vagrant/files/ && ./follower.sh"

  # echo "Start the wallet"
  # ssh -n follower "cd /vagrant/files/ && ./wallet.sh" 

  # echo "Add entries"
  # ssh -n follower "cd /vagrant/files/ && ./entries.sh &"  

  echo "Block Heights. CTRL-C to quit."

  while true ;
  do
    date
    L="$(ssh -n leader "/vagrant/files/factom-cli get height")"
    F="$(ssh -n follower "/vagrant/files/factom-cli get height")"
    echo "Leader: ${L} Follower: ${F}"
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
