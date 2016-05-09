#!/bin/bash +x

# preserve does the heavy lifting
function preserve(){
# $1 is the passed in directory named
# $2 is the ssh alias for the host
local name="$1-$2"
echo "Tar runlog and .factom to a file named $name.tz"
ssh -n $2 "tar czf ~/$name.tz  ~/runlog.txt ~/.factom"
}
function remove(){
# $1 is the passed in directory named
# $2 is the ssh alias for the host
local name="$1-$2"
echo "removing file named $name.tz"
ssh -n $2 "rm ~/$name.tz"
}

echo "Usage: all_preserve.sh <Name-of-Directory>"

echo "Preserving runlog and .factom in a directory named $1"

while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "Preserving: $line"
  preserve $1 $line 
  #  remove $1 $line 
done < "./leaders.conf"

while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "Preserving: $line"
  preserve $1 $line
  #  remove $1 $line 
done < "./followers.conf"


