#!/bin/bash +x

echo
echo 1 WALLETS
echo
echo 1.1 FACTOID WALLET
echo
echo 1.1.1 CREATE FACTOID WALLET ADDRESSES        
echo
echo 1.1.1.1 CREATE LEGITIMATE FACTOID WALLET ADDRESS NAMES        
FACTOIDWALLETADDRESSKEY01=$(factom-cli generateaddress fct factoid-wallet-address-name01 | awk '{print $3}')
echo factoid-wallet-address-name01 = $FACTOIDWALLETADDRESSKEY01
echo 
FACTOIDWALLETADDRESSKEY02=$(factom-cli generateaddress fct factoid-wallet-address-name02 | awk '{print $3}')
echo factoid-wallet-address-name02 = $FACTOIDWALLETADDRESSKEY02
echo 
echo 1.1.1.2 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH '"$"'        
factom-cli generateaddress fct '$F01'
echo 
echo 1.1.1.3 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH '"/"'        
factom-cli generateaddress fct "'/F02'"
echo 
echo 1.1.1.4 TRY TO CREATE TOO LONG FACTOID WALLET ADDRESS NAME       
factom-cli generateaddress fct factoid-wallet-address-name890123
echo

echo 1.1.2 GET FACTOID WALLET ADDRESS BALANCES        
echo
echo 1.1.2.1 LIST ALL WALLET ADDRESS BALANCES        
factom-cli getaddresses
echo 
echo 1.1.2.2 LIST FACTOID WALLET ADDRESS BALANCES INDIVIDUALLY        
factom-cli balance fct factoid-wallet-address-name01
factom-cli balance fct $FACTOIDWALLETADDRESSKEY01
factom-cli balance fct factoid-wallet-address-name02
factom-cli balance fct $FACTOIDWALLETADDRESSKEY02
echo 
echo 1.1.2.3 REQUEST BALANCE OF NON-EXISTENT FACTOID WALLET ADDRESS
factom-cli balance fct factom-cli balance fct xxx
echo 
echo 1.1.2.4 REQUEST BALANCE OF FACTOID WALLET ADDRESS NAME TOO LONG
factom-cli balance fct hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhaaaa
echo

echo 1.2 ENTRY CREDIT WALLET        
echo
echo 1.2.1 CREATE ENTRY CREDIT WALLET ADDRESSES
echo
echo 1.2.1.1 CREATE ORDINARY ENTRY CREDIT WALLET ADDRESS NAMES        
ECWALLETADDRESSKEY01=$(factom-cli generateaddress ec ec-wallet-address-name01 | awk '{print $3}')
echo ec-wallet-address-name01 = $ECWALLETADDRESSKEY01
echo
ECWALLETADDRESSKEY02=$(factom-cli generateaddress ec ec-wallet-address-name02 | awk '{print $3}')
echo ec-wallet-address-name02 = $ECWALLETADDRESSKEY02
echo
echo 1.2.1.2 TRY TO CREATE ENTRY CREDIT WALLET ADDRESS NAME STARTING WITH '"$"'        
factom-cli generateaddress ec '$E01'
echo 
echo 1.2.1.3 TRY TO CREATE ENTRY CREDIT WALLET ADDRESS NAME STARTING WITH '"/"'        
factom-cli generateaddress ec "'/E02'"
echo 
echo 1.2.1.2 TRY TO CREATE TOO LONG ENTRY CREDIT WALLET ADDRESS NAME       
factom-cli generateaddress ec entry-credit-wallet-address-name01
echo

echo 1.2.2 GET ENTRY CREDIT WALLET ADDRESS BALANCES        
echo
echo 1.2.2.1 LIST ALL ENTRY CREDIT WALLET ADDRESS BALANCES        
factom-cli getaddresses
echo
echo 1.2.2.2 LIST ENTRY CREDIT WALLET ADDRESS BALANCES INDIVIDUALLY        
factom-cli balance ec ec-wallet-address-name01
factom-cli balance ec $ECWALLETADDRESSKEY01
factom-cli balance ec ec-wallet-address-name02
factom-cli balance ec $ECWALLETADDRESSKEY02
echo
echo 1.2.2.3 REQUEST BALANCE OF NON-EXISTENT ENTRY CREDIT WALLET ADDRESS
factom-cli balance ec xxx
echo 
echo 1.2.2.4 REQUEST BALANCE OF ENTRY CREDIT WALLET ADDRESS NAME TOO LONG
factom-cli balance ec hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhaaaa
echo

echo 2  TRANSACTIONS        
echo
echo 2.1  TRANSACTION FEE        
factom-cli getfee
echo

echo 2.2 CREATE TRANSACTION WITH NO INPUTS OUTPUTS OR ENTRY CREDITS
echo
echo 2.2.1  CREATE TRANSACTION        
factom-cli newtransaction transaction01
echo
echo 2.2.2  SUBMIT TRANSACTION        
factom-cli submit transaction01
echo
echo 2.2.3  SIGN TRANSACTION        
factom-cli sign transaction01
echo
echo 2.2.4  ADD JUST ENOUGH INPUT TO COVER TRANSACTION FEE        
factom-cli addinput transaction01 factoid-wallet-address-name01 1
echo
echo 2.2.5  RE-SIGN TRANSACTION        
factom-cli sign transaction01
echo
echo 2.2.6  SUBMIT TRANSACTION        
factom-cli submit transaction01
echo
echo 2.2.7  VERIFY WALLET BALANCES        
factom-cli getaddresses
echo

echo 2.3 CREATE TRANSACTION WITH NO INPUTS
echo
echo 2.3.1 CREATE TRANSACTION        
factom-cli newtransaction transaction02
echo
echo 2.3.2 ADD OUTPUT OF 3 FACTOIDS TO TRANSACTION        
factom-cli addoutput transaction02 factoid-wallet-address-name02 3
echo
echo 2.3.3 SIGN TRANSACTION        
factom-cli sign transaction02
echo
echo 2.3.4 SUBMIT TRANSACTION        
factom-cli submit transaction02
echo
echo 2.3.5 VERIFY WALLET BALANCES        
factom-cli getaddresses
echo

echo 2.4 CREATE TRANSACTION WITH NO OUTPUTS OR ENTRY CREDITS
echo
echo 2.4.1 CREATE TRANSACTION        
factom-cli newtransaction transaction03
echo
echo 2.4.2 ADD INPUT OF 100 FACTOIDS TO TRANSACTION        
factom-cli addinput transaction03 factoid-wallet-address-name01 100
echo
echo 2.4.3 SIGN TRANSACTION        
factom-cli sign transaction03
echo
echo 2.4.4 SUBMIT TRANSACTION        
factom-cli submit transaction03
echo
echo 2.4.5 VERIFY WALLET BALANCES        
factom-cli getaddresses
echo

echo 2.5 CREATE TRANSACTION WITH INPUT TO ENTRY CREDITS
echo
echo 2.5.1 CREATE TRANSACTION        
factom-cli newtransaction transaction04
echo
echo 2.5.2 ADD INPUT OF 100 FACTOIDS TO TRANSACTION        
factom-cli addinput transaction04 factoid-wallet-address-name01 100
echo
echo 2.5.3 ADD 6 FACTOIDS OF ENTRY CREDITS FOR 1ST ENTRY CREDIT WALLET TO TRANSACTION        
factom-cli addecoutput transaction04 ec-wallet-address-name01 6
echo
echo 2.5.4 ADD -6 FACTOIDS OF ENTRY CREDITS FOR 1ST ENTRY CREDIT WALLET TO TRANSACTION        
factom-cli addecoutput transaction04 ec-wallet-address-name01 -6
echo
echo 2.5.5 SIGN TRANSACTION        
factom-cli sign transaction04
echo
echo 2.5.6 SUBMIT TRANSACTION        
factom-cli submit transaction04
echo
echo 2.5.7 VERIFY WALLET BALANCES        
factom-cli getaddresses
echo

echo 2.6 CREATE TRANSACTION WITH INPUT TO OUTPUT
echo
echo 2.6.1 CREATE TRANSACTION        
factom-cli newtransaction transaction05
echo
echo 2.6.2 ADD INPUT OF 100 FACTOIDS TO TRANSACTION        
factom-cli addinput transaction05 factoid-wallet-address-name01 100
echo
echo 2.6.3 ADD OUTPUT OF 3 FACTOIDS TO SAME FACTOID WALLET ADDRESS AS INPUT CAME FROM TO TRANSACTION        
factom-cli addoutput transaction05 factoid-wallet-address-name01 3
echo
echo 2.6.4 ADD OUTPUT OF 5 FACTOIDS TO NON-EXISTING FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addoutput transaction05 xxx 5
echo
echo 2.6.5 SIGN TRANSACTION        
factom-cli sign transaction05
echo
echo 2.6.6 SUBMIT TRANSACTION        
factom-cli submit transaction05
echo
echo 2.6.7 VERIFY WALLET BALANCES        
factom-cli getaddresses
echo

echo 2.7 CREATE TRANSACTION WITH INPUT TO OUTPUT AND ENTRY CREDITS        
echo
echo 2.7.1 CREATE TRANSACTION        
factom-cli newtransaction transaction06
echo
echo 2.7.2 ADD INPUT TO TRANSACTION        
echo
echo 2.7.2.1 ADD INPUT OF 100 FACTOIDS TO TRANSACTION        
factom-cli addinput transaction06 factoid-wallet-address-name01 100
echo
echo 2.7.3  ADD OUTPUT TO TRANSACTION        
echo
echo 2.7.3.1 ADD OUTPUT OF 3.33333333 FACTOIDS TO TRANSACTION        
factom-cli addoutput transaction06 factoid-wallet-address-name02 3.33333333
echo
echo 2.7.4  ADD PURCHASE OF ENTRY CREDITS TO TRANSACTION 
echo
echo 2.7.4.1 ADD 6 FACTOIDS OF ENTRY CREDITS FOR 1ST ENTRY CREDIT WALLET TO TRANSACTION        
factom-cli addecoutput transaction06 $ECWALLETADDRESSKEY01 6
echo
echo 2.7.5 SIGN TRANSACTION        
factom-cli sign transaction06
echo
echo 2.7.6 SUBMIT TRANSACTION        
factom-cli submit transaction06
echo
echo 2.7.7 VERIFY WALLET BALANCES        
factom-cli getaddresses
echo

echo 2.8 CREATE TRANSACTION WITH MULTIPLE INPUT OUTPUT AND ENTRY CREDITS        
echo
echo 2.8.1 CREATE TRANSACTION        
factom-cli newtransaction transaction07
echo
echo 2.8.2 ADD INPUTS TO TRANSACTION        
echo
echo 2.8.2.1 ADD 1ST INPUT FROM 1ST FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addinput transaction07 factoid-wallet-address-name01 100
echo
echo 2.8.2.2 ADD 2ND INPUT FROM 1ST FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addinput transaction07 factoid-wallet-address-name01 300
echo
echo 2.8.2.3 ADD INPUT FROM 2ND FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addinput transaction07 factoid-wallet-address-name02 200
echo
echo 2.8.3 ADD OUTPUTS TO TRANSACTION        
echo
echo 2.8.3.1 ADD 1ST OUTPUT FROM 1ST FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addoutput transaction07 factoid-wallet-address-name01 4.44444444
echo
echo 2.8.3.2 ADD 2ND OUTPUT FROM 1ST FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addoutput transaction07 factoid-wallet-address-name01 5.55555555
echo
echo 2.8.3.3 ADD OUTPUT FROM 2ND FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addoutput transaction07 factoid-wallet-address-name02 6.66666666
echo
echo 2.8.4 ADD ENTRY CREDIT PURCHASES TO TRANSACTION 
echo
echo 2.8.4.1 ADD 1ST PURCHASE TO 1ST ENTRY CREDIT WALLET ADDRESS TO TRANSACTION        
factom-cli addecoutput transaction07 $ECWALLETADDRESSKEY01 7
echo
echo 2.8.4.2 ADD 2ND PURCHASE TO 1ST ENTRY CREDIT WALLET ADDRESS TO TRANSACTION        
factom-cli addecoutput transaction07 $ECWALLETADDRESSKEY01 8
echo
echo 2.8.4.3 ADD 2ND PURCHASE TO 1ST ENTRY CREDIT WALLET ADDRESS TO TRANSACTION        
factom-cli addecoutput transaction07 $ECWALLETADDRESSKEY02 9
echo
echo 2.8.5 COMPLEX TRANSACTION FEE        
factom-cli getfee transaction07
echo
echo 2.8.6 SIGN TRANSACTION        
factom-cli sign transaction07
echo
echo 2.8.7 SUBMIT TRANSACTION        
factom-cli submit transaction07
echo
echo 2.8.8 VERIFY WALLET BALANCES        
factom-cli getaddresses
echo

echo 2.9 TEST TRANSACTION PARAMETER LIMITS
echo
echo 2.9.1 ADD INPUT OF -1 FACTOIDS TO TRANSACTION        
factom-cli balance fct factoid-wallet-address-name01
factom-cli newtransaction transaction08
factom-cli addinput transaction08 factoid-wallet-address-name01 -1
factom-cli sign transaction08
factom-cli submit transaction08
factom-cli balance fct factoid-wallet-address-name01
echo

echo 2.9.2 ADD INPUT OF 0 FACTOIDS TO TRANSACTION        
factom-cli generateaddress fct factoid-wallet-address-name03
factom-cli balance fct factoid-wallet-address-name03
factom-cli newtransaction transaction09
factom-cli addinput transaction09 factoid-wallet-address-name03 0
factom-cli sign transaction09
factom-cli submit transaction09
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.3 ADD FRACTIONAL INPUT OF FACTOIDS WITHOUT LEADING 0 TO TRANSACTION        
factom-cli newtransaction transaction10
factom-cli addinput transaction10 factoid-wallet-address-name03 .5
factom-cli sign transaction10
factom-cli submit transaction10
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.4 ADD TOO SMALL INPUT OF 0.000000009 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction11
factom-cli addinput transaction11 factoid-wallet-address-name03 0.000000009
factom-cli sign transaction11
factom-cli submit transaction11
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.5 ADD JUST LESS THAN MINIMUM INPUT OF 0.01333333 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction12
factom-cli addinput transaction12 factoid-wallet-address-name03 0.01333333
factom-cli sign transaction12
factom-cli submit transaction12
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.6 ADD MINIMUM INPUT OF 0.01333334 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction13
factom-cli addinput transaction13 factoid-wallet-address-name03 0.01333334
factom-cli sign transaction13
factom-cli submit transaction13
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.7 ADD LARGEST ALLOWABLE INPUT OF 92233720368.54775806 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction14
factom-cli addinput transaction14 factoid-wallet-address-name03 92233720368.54775806
factom-cli sign transaction14
factom-cli submit transaction14
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.8 ADD TOO LARGE INPUT OF 92233720369 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction15
factom-cli addinput transaction15 factoid-wallet-address-name03 92233720369
factom-cli sign transaction15
factom-cli submit transaction15
factom-cli balance fct factoid-wallet-address-name03
echo

# CHECK ALL CHARACTERS EVENTUALLY (!@+*ETC)

echo 3 CHAIN
echo
echo 3.1 MAKE A CHAIN
echo
echo 3.1.1 TRY TO MAKE CHAIN USING NON-EXISTENT ENTRY CREDIT ADDRESS
echo
CHAINID=$(factom-cli mkchain -e 111111 -e 222222 xxx <~/testing/testing/test-plans-and-scripts/entries/1st-entry | awk '{print $3}')
echo New Chain ID
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec xxx
echo

echo 3.1.2 MAKE CHAIN USING ENTRY CREDIT ADDRESS NAME
echo
factom-cli balance ec ec-wallet-address-name01
CHAINIDGOOD=$(factom-cli mkchain -e 111111 -e 222222 ec-wallet-address-name01 <~/testing/testing/test-plans-and-scripts/entries/1st-entry | awk '{printf $3}')
echo New Chain ID
echo $CHAINIDGOOD
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
HEADGOOD=$(factom-cli get chain $CHAINIDGOOD)
echo $HEADGOOD
factom-cli balance ec ec-wallet-address-name01
echo

echo 3.1.3 MAKE CHAIN THAT ALREADY EXISTS
echo
factom-cli balance ec ec-wallet-address-name01
CHAINID=$(factom-cli mkchain -e 111111 -e 222222 ec-wallet-address-name01 <~/testing/testing/test-plans-and-scripts/entries/1st-entry | awk '{printf $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec ec-wallet-address-name01
echo

echo 3.1.4 MAKE SAME CHAIN USING DIFFERENT EXTERNAL ID
echo
CHAINID=$(factom-cli mkchain -e 111111 -e 222222 ec-wallet-address-name01 <~/testing/testing/test-plans-and-scripts/entries/2nd-entry | awk '{printf $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec $ECWALLETADDRESSKEY01
echo

echo 3.1.5 MAKE CHAIN USING A ENTRY CREDIT ADDRESS KEY
echo
HOUR=$( date +%H )
MINUTE=$( date +%M )
CHAINID=$(factom-cli mkchain -e $HOUR -e $MINUTE $ECWALLETADDRESSKEY01 <~/testing/testing/test-plans-and-scripts/entries/1st-entry | awk '{printf $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec $ECWALLETADDRESSKEY01
echo

echo 3.2 TRACE ENTRY BLOCK CHAIN
ENTRYKEYMERKELROOT=$HEADGOOD
until [ "$ENTRYKEYMERKELROOT" =  '0000000000000000000000000000000000000000000000000000000000000000' -o "$ENTRYKEYMERKELROOT" = "" ]; do
    RESULT=$(factom-cli get eblock $ENTRYKEYMERKELROOT)
#   echo $RESULT
    SEQNO=$(echo $RESULT | awk '{printf $2}')
    TIMESTAMP=$(echo $RESULT | awk '{printf $8}')    
    EBCHAINID=$(echo $RESULT | awk '{printf $4}')
    ENTRYKEYMERKELROOT=$(echo $RESULT | awk '{printf $6}')
    echo ENTRY BLOCK
    echo -----------
    echo Sequence Number - Time Stamp
    echo $SEQNO $TIMESTAMP
    echo Chain ID
    echo $EBCHAINID
    echo Previous Entry Block Key Merkel Root 
    echo $ENTRYKEYMERKELROOT
    echo
    ENTRYINDEX=12
    ENTRYTIMESTAMP=$(echo $RESULT | awk '{printf $12}')
    until [ "$ENTRYTIMESTAMP" = "" ]; do
        echo "    "ENTRY
        echo "    "-----
        echo "    "Entry Time Stamp
        echo "    "$ENTRYTIMESTAMP
        echo "    "Entry Hash
        ENTRYHASH=$(echo $RESULT | awk -v INDEX="$(($ENTRYINDEX + 2))" '{printf $INDEX}')
        echo "    "$ENTRYHASH
        factom-cli get entry $ENTRYHASH 
        ((ENTRYINDEX+=7))
        ENTRYTIMESTAMP=$(echo $RESULT | awk -v INDEX="$ENTRYINDEX" '{printf $INDEX}')
    echo
    done
done
echo

echo 3.2 ENTRY
echo 3.2.1 PUT ENTRY
factom-cli put -e 333333 -e 444444 -c $CHAINIDGOOD ec-wallet-address-name01 <~/testing/testing/test-plans-and-scripts/entries/2nd-entry
HEADGOOD=$(factom-cli get chain $CHAINIDGOOD)
echo Chain Head Merkelroot
echo $HEADGOOD

echo 3.2 TRACE ENTRY BLOCK CHAIN
ENTRYKEYMERKELROOT=$HEADGOOD
until [ "$ENTRYKEYMERKELROOT" =  '0000000000000000000000000000000000000000000000000000000000000000' -o "$ENTRYKEYMERKELROOT" = "" ]; do
    RESULT=$(factom-cli get eblock $ENTRYKEYMERKELROOT)
#   echo $RESULT
    SEQNO=$(echo $RESULT | awk '{printf $2}')
    TIMESTAMP=$(echo $RESULT | awk '{printf $8}')    
    EBCHAINID=$(echo $RESULT | awk '{printf $4}')
    ENTRYKEYMERKELROOT=$(echo $RESULT | awk '{printf $6}')
    echo ENTRY BLOCK
    echo -----------
    echo Sequence Number - Time Stamp
    echo $SEQNO $TIMESTAMP
    echo Chain ID
    echo $EBCHAINID
    echo Previous Entry Block Key Merkel Root 
    echo $ENTRYKEYMERKELROOT
    echo
    ENTRYINDEX=12
    ENTRYTIMESTAMP=$(echo $RESULT | awk '{printf $12}')
    until [ "$ENTRYTIMESTAMP" = "" ]; do
        echo "    "ENTRY
        echo "    "-----
        echo "    "Entry Time Stamp
        echo "    "$ENTRYTIMESTAMP
        echo "    "Entry Hash
        ENTRYHASH=$(echo $RESULT | awk -v INDEX="$(($ENTRYINDEX + 2))" '{printf $INDEX}')
        echo "    "$ENTRYHASH
        factom-cli get entry $ENTRYHASH 
        ((ENTRYINDEX+=7))
        ENTRYTIMESTAMP=$(echo $RESULT | awk -v INDEX="$ENTRYINDEX" '{printf $INDEX}')
    echo
    done
done
echo

#'s/[{}]//g'  | sed 's/^.//'  | sed 's/.$//'
echo 3.3  TRACE DIRECTORY BLOCK CHAIN
HEAD=$(factom-cli get head)
echo $HEAD
DIRECTORYKEYMERKELROOT=$HEAD
until [ "$DIRECTORYKEYMERKELROOT" = "0000000000000000000000000000000000000000000000000000000000000000" -o "$DIRECTORYKEYMERKELROOT" = "" ]; do
    RESULT=$(factom-cli get dblock $DIRECTORYKEYMERKELROOT)
#   echo $RESULT
    DIRECTORYKEYMERKELROOT=$(echo $RESULT | awk '{printf $2}')
    TIMESTAMP=$(echo $RESULT | awk '{printf $4}')    
    SEQNO=$(echo $RESULT | awk '{printf $6}')
    echo DIRECTORY BLOCK
    echo ---------------
    echo Previous Directory Block Key Merkel Root - Time Stamp - Sequence Number
    echo $DIRECTORYKEYMERKELROOT $TIMESTAMP $SEQNO
    echo
    EBCHAINIDINDEX=10
    EBCHAINID=$(echo $RESULT | awk '{printf $10}')
    until [ "$EBCHAINID" = "" ]; do
        EBKEYMERKELROOT=$(echo $RESULT | awk -v INDEX="$(($EBCHAINIDINDEX + 2))" '{printf $INDEX}')
        echo "    "ENTRY BLOCK
        echo "    "-----------
        echo "    "Entry Block Chain ID
        echo "    "$EBCHAINID
        echo "    "Entry Block Key Merkel Root
        echo "    "$EBKEYMERKELROOT
        ((EBCHAINIDINDEX+=7))
        EBCHAINID=$(echo $RESULT | awk -v INDEX="$EBCHAINIDINDEX" '{printf $INDEX}')
    echo
    done
done
echo

: <<'EOF'

EOF









