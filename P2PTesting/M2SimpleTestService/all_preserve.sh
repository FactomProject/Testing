#!/bin/bash +x

# # preserve does the heavy lifting
# function preserve(){
# # $1 is the passed in directory named
# # $2 is the ssh alias for the host
# local name="$1-$2"
# echo "Tar runlog and .factom to a file named $name.tz"
# ssh -n $2 "tar czf ~/$name.tz  ~/runlog.txt ~/.factom"
# }
# function remove(){
# # $1 is the passed in directory named
# # $2 is the ssh alias for the host
# local name="$1-$2"
# echo "removing file named $name.tz"
# ssh -n $2 "rm ~/$name.tz"
# }

echo "Usage: all_preserve.sh"

directory=`date +logs-%Y-%m-%d-%H_%M`
path="./runlogs/"

echo "Preserving runlog.txt and message_log.csv in a directory named $directory"

mkdir $path$directory
while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "Preserving: $line"
ssh -n $line "tar czf $line-runlog.tz runlog.txt"
ssh -n $line "tar czf $line-messagelog.tz message_log.csv"
scp $line:~/$line-runlog.tz $path$directory
scp $line:~/$line-messagelog.tz $path$directory
ssh -n $line "rm ~/$line-runlog.tz" 
ssh -n $line "rm ~/$line-messagelog.tz"  
cd $path$directory
tar -xvf $line-runlog.tz -O > $line-runlog.txt
tar -xvf $line-messagelog.tz -O > $line-messagelog.csv
cd ../..
  # preserve $1 $line 
  #  remove $1 $line 
done < "./leaders.conf"

while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "Preserving: $line"
  # preserve $1 $line
  #  remove $1 $line 
  ssh -n $line "tar czf $line-runlog.tz runlog.txt"
ssh -n $line "tar czf $line-messagelog.tz message_log.csv"
scp $line:~/$line-runlog.tz $path$directory
scp $line:~/$line-messagelog.tz $path$directory
ssh -n $line "rm ~/$line-runlog.tz"
ssh -n $line "rm ~/$line-messagelog.tz"
cd $path$directory
tar -xvf $line-runlog.tz -O > $line-runlog.txt
tar -xvf $line-messagelog.tz -O > $line-messagelog.csv
rm *.tz
cd ../..
done < "./followers.conf"


