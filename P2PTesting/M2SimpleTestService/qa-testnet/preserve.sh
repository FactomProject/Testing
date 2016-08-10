#!/bin/bash +x

directory=`date +logs-%Y%m%d-%H_%M`
path="../logs/"

echo "Preserving runlog.txt and message_log.csv in a directory named $directory"

mkdir $path$directory

echo "Preserving the logs in $path$directory"

function godo {
    echo "Preserving $1"
    ssh -n $1 "touch runlog.txt"
    ssh -n $1 "touch message_log.csv"
    ssh -n $1 "tar czf $1-runlog.tz runlog.txt"
    ssh -n $1 "tar czf $1-messagelog.tz message_log.csv"
    ssh -n $1 "tar czf $1-dotfactom.tz .factom"
    scp $1:~/$1-runlog.tz $path$directory
    scp $1:~/$1-messagelog.tz $path$directory
    scp $1:~/$1-dotfactom.tz $path$directory
    ssh -n $1 "rm ~/$1-runlog.tz"
    ssh -n $1 "rm ~/$1-messagelog.tz"
    ssh -n $1 "rm ~/$1-dotfactom.tz"
    tar -xvf $path$directory/$1-runlog.tz -O > $path$directory/$1-runlog.txt
    tar -xvf $path$directory/$1-messagelog.tz -O > $path$directory/$1-messagelog.csv
    rm $path$directory/*log.tz
}

godo tda 
godo tdb
godo tdc
godo tdd