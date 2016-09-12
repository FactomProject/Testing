#!/bin/bash

TMPDIR="/tmp/factomd-p2p-test-build"
mkdir $TMPDIR

# do the grep
# $1=file $2=id $3=stage
function counts {
    COUNT=`grep -i ", $3, $2, Message," $1 | wc -l`
    echo "$2 $3 $COUNT"
}

# Iterate the stages
# $1=file $2=id $3=Name
function stages {
    echo "Status for $3"
    counts $1 $2 "a"
    counts $1 $2 "b"
    counts $1 $2 "c"
    counts $1 $2 "d"
    counts $1 $2 "e"
    counts $1 $2 "f"
    counts $1 $2 "g"
    counts $1 $2 "h"
    counts $1 $2 "i"
    counts $1 $2 "j"
    counts $1 $2 "k"
    counts $1 $2 "l"
}

# Iterate the messages
# $1 = file
function messages {
    stages $1 "0" "EOM_MSG"
    stages $1 "1" "ACK_MSG"
    stages $1 "8" "EOM_TIMEOUT_MSG"
    stages $1 "10" "HEARTBEAT_MSG"
    stages $1 "14" "REQUEST_BLOCK_MSG"
    stages $1 "16" "MISSING_MSG"
    stages $1 "17" "MISSING_DATA"
    stages $1 "18" "DATA_RESPONSE"
    stages $1 "19" "MISSING_MSG_RESPONSE"
    stages $1 "20" "DBSTATE_MSG"
    stages $1 "21" "DBSTATE_MISSING_MSG"
}


../process_cluster_test.sh > $TMPDIR/pct.out

echo "Filtering and sorting..."

cat $TMPDIR/pct.out | grep '^ParcelTrace, ' | sort -f > $TMPDIR/messages.out

echo "analyzing..."

tail -10000 $TMPDIR/pct.out | grep -B 3 -A 11 "InMsgQueue"

messages $TMPDIR/pct.out