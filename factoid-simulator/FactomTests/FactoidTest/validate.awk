
# This is to fix the fact that without modifing Factom, the Genesis block is already
# complete before we can print.  So it already has the reward added.  But to make our
# code work, we need to remove the reward.

BEGIN { err[0]; delete err[0] }

/200000000000 300000000000/ {
    $5 = 200000000000
}

{ cnt++ }

/^Transaction/ { transCnt++ }
/^Block/ { blockCnt++ }
/^Randomize/ { seed=$4 }
/^out / {
    addr[$3]+=$4
    if (addr[$3] != $5) {
        err[$3] = cnt " output " $3 " has a balance of " addr[$3] " but Factom thinks " $5 
    }else{
        delete err[$3]
        goodOutput++
    }
}

/^in / {
    addr[$3]-=$4
    if (addr[$3] != $5) {
        err[$3] = cnt " input " $3 " has a balance of " addr[$3] " but Factom thinks " $5 
    }else{
        delete err[$3]
        goodInput++
    }
}

/^ec / {
    ecaddr[$3]+=$4
    if (ecaddr[$3] != $5) {
        err[$3] = cnt " ecoutput " $3 " has a balance of " ecaddr[$3] " but Factom thinks " $5 
    }else{
        delete err[$3]
        goodECOutput++
    }
}

END {
    print "Seed = " seed
    print "Processed " transCnt " Transactions and " blockCnt " blocks"
    print "Found " length(err) " Errors"
    print "Found " goodInput " Good Inputs"
    print "Found " goodOutput " Good Outputs"
    print "Found " goodECOutput " Good ECOutputs"
    
    for (x in err) {
        print err[x]
    }
}
