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

echo "Usage: all_preserve.sh /path/to/store/logs/"

directory=`date +logs-%Y%m%d-%H_%M`
# path="./runlogs/"
path=$1
echo "Preserving runlog.txt and message_log.csv in a directory named $directory"

mkdir $path$directory

while IFS='' read -r line || [[ -n "$line" ]]; do
echo "Preserving: $line"
ssh -n $line "touch runlog.txt"
ssh -n $line "touch message_log.csv"
ssh -n $line "tar czf $line-runlog.tz runlog.txt"
ssh -n $line "tar czf $line-messagelog.tz message_log.csv"
scp $line:~/$line-runlog.tz $path$directory
scp $line:~/$line-messagelog.tz $path$directory
ssh -n $line "rm ~/$line-runlog.tz"
ssh -n $line "rm ~/$line-messagelog.tz"
tar -xvf $path$directory/$line-runlog.tz -O > $path$directory/$line-runlog.txt
tar -xvf $path$directory/$line-messagelog.tz -O > $path$directory/$line-messagelog.csv
rm $path$directory/*.tz
done < "./leaders.conf"

while IFS='' read -r line || [[ -n "$line" ]]; do
echo "Preserving: $line"
ssh -n $line "touch runlog.txt"
ssh -n $line "touch message_log.csv"
ssh -n $line "tar czf $line-runlog.tz runlog.txt"
ssh -n $line "tar czf $line-messagelog.tz message_log.csv"
scp $line:~/$line-runlog.tz $path$directory
scp $line:~/$line-messagelog.tz $path$directory
ssh -n $line "rm ~/$line-runlog.tz"
ssh -n $line "rm ~/$line-messagelog.tz"
tar -xvf $path$directory/$line-runlog.tz -O > $path$directory/$line-runlog.txt
tar -xvf $path$directory/$line-messagelog.tz -O > $path$directory/$line-messagelog.csv
rm $path$directory/*.tz
done < "./followers.conf"


