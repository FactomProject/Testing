#!/bin/bash +x

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
  scp stop.sh $1:~/
  scp $2 $1:~/start.sh
  scp new_run_header.sh $1:~/
  scp r $1:~/
  scp -r ../../../factomd/controlPanel/Web $1:~/.factom/m2/
  echo "Removing previous log file."
  ssh -n $1 'echo \"Config Remote Test Box Reset\" > runlog.txt'
}