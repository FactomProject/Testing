#!/usr/bin/env bash

echo "This sets up vagrant boxes, builds factomd, installs it, and then runs it."

$leader="brian_leader"
$follower="brian_follower"

# reset_dot_factom MachineAlias 
function reset_dot_factom {
  echo "Stop factomd etc on $1."
  ssh -n $1 "pkill factomd; pkill factom-walletd; pkill factom-cli"
  echo "resetting ~/.factom on $1."
  ssh -n $1 "rm -rf ~/.factom"
  ssh -n $1 "mkdir ~/.factom"
  ssh -n $1 "mkdir ~/.factom/m2"
  ssh -n $1 "cp /vagrant/files/factomd.conf ~/.factom/m2"
}

# sleep_with_dots time_in_seconds
function sleep_with_dots {
  printf "Sleeping for %1 seconds.\n"
  for i in $(seq $1); do
    printf "."
    sleep 1
  done
}


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
  sleep_with_dots 2
  vagrant up
  
  echo "$leader Timestamp:"
  ssh $leader "date"
  echo "$follower Timestamp:"
  ssh $follower "date"

  reset_dot_factom $leader
  reset_dot_factom $follower
  
  echo "Start the $leader"
  ssh -n $leader "cd /vagrant/files/ && ./leader.sh" 

  echo "Start the $follower"
  ssh -n $follower "cd /vagrant/files/ && ./follower.sh"

  sleep 20

  echo "Start the wallet on $leader"
  ssh -n $leader "cd /vagrant/files/ && ./wallet.sh" 

  echo "Start the wallet on $follower"
  ssh -n $follower "cd /vagrant/files/ && ./wallet.sh" 

  echo "Sleep while waiting for the $leader to make blocks."
  sleep_with_dots 300

  echo "Add entries on $follower"
  ssh -n $follower "cd /vagrant/files/ && ./entries.sh &"  

  sleep_with_dots 20

  echo "Verify entries made it onto $leader blockchain"
  # ssh -n $follower "/vagrant/files/factom-cli listaddresses"
  ssh -n $leader "/vagrant/files/factom-cli listaddresses"
  ssh -n $leader "/vagrant/files/factom-cli get allentries b69469af5a875cfd50786827e92171a84232bd7a198fa29234ac931e40a342c3"
  # ssh -n $follower "/vagrant/files/factom-cli get allentries b69469af5a875cfd50786827e92171a84232bd7a198fa29234ac931e40a342c3"

  echo "Sleep while waiting for the $leader to make blocks."
  sleep_with_dots 300

  echo "Now going to reset the follower to check catchup time."
  reset_dot_factom $follower

  # echo "Turn off latency on the $follower"
  # ssh -n $follower "sudo tc qdisc del dev eth0 root"
  # ssh -n $follower "sudo tc qdisc del dev eth1 root"

  echo "Turn on latency on the $follower"
  # Hit both network interfaces, because the NAT and private/host only seem to change between create/destroy.
  ssh -n $follower "sudo tc qdisc add dev eth1 root netem delay 400ms"
  ssh -n $follower "sudo tc qdisc add dev eth0 root netem delay 400ms"

  echo "$follower to $leader Ping:"
  ssh -n $follower "ping -c 3 10.0.99.3"

  echo "$leader to $follower Ping:"
  ssh -n $leader "ping -c 3 10.0.99.2"

  echo "Start the $follower"
  ssh -n $follower "cd /vagrant/files/ && ./follower.sh"

  echo "Observe the time the follower takes to catch up."

  echo "Block Heights. CTRL-C to quit."
 for i in $(seq 100); do
    printf "$(date) - "
    L="$(ssh -n $leader "/vagrant/files/factom-cli get height")"
    F="$(ssh -n $follower "/vagrant/files/factom-cli get height")"
    printf "$leader: ${L} $follower: ${F} \n"
    sleep 1
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
