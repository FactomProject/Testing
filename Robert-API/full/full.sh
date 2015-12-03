#!/bin/bash +x

MAKE-CHAIN ()
{
    echo Proposed New Chain ID
    CHAINID=$(factom-cli mkchain -e $1 $2 $3 $4 <$5 | awk '{print $3}')
    echo CHAINID=$CHAINID
    GET-ENTRY-BLOCK-CHAIN-HEAD $CHAINID
}

GET-ENTRY-BLOCK-CHAIN-HEAD ()
{
    echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
    sleep 60
    echo Chain Head Merkelroot
    HEAD=$(factom-cli get chain $1)
    echo HEAD = $HEAD
    factom-cli getaddresses
}

TRACE-UPDATED-ENTRY-BLOCK-CHAIN ()
{
    GET-ENTRY-BLOCK-CHAIN-HEAD $CHAINIDGOOD
    HEADGOOD=$HEAD
    echo HEADGOOD = $HEADGOOD
    echo
    TRACE-ENTRY-BLOCK-CHAIN $HEADGOOD
}

TRACE-ENTRY-BLOCK-CHAIN ()
{
    ENTRYKEYMERKELROOT=$1
    echo HEAD = $HEAD
    echo HEADGOOD = $HEADGOOD
    echo ENTRYKEYMERKELROOT = $ENTRYKEYMERKELROOT
    echo
    until [ "$ENTRYKEYMERKELROOT" = '0000000000000000000000000000000000000000000000000000000000000000' -o "$ENTRYKEYMERKELROOT" = "" ]; do
        RESULT=$(factom-cli get eblock $ENTRYKEYMERKELROOT)
#       echo $RESULT
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
}

echo WAITING 60 SECONDS FOR FACTOMD TO INITIALIZE
sleep 60
echo
echo 1 WALLETS
echo
echo 1.1 FACTOID WALLET
echo
echo 1.1.1 CREATE FACTOID WALLET ADDRESSES        
echo
echo 1.1.1.1 CREATE TWO LEGITIMATE FACTOID WALLET ADDRESSES
FACTOIDWALLETADDRESSKEY01=$(factom-cli newaddress fct factoid-wallet-address-name01 Fs2DNirmGDtnAZGXqca3XHkukTNMxoMGFFQxJA3bAjJnKzzsZBMH | awk '{print $3}')        
echo FACTOIDWALLETADDRESSKEY01=$FACTOIDWALLETADDRESSKEY01
FACTOIDWALLETADDRESSKEY02=$(factom-cli generateaddress fct factoid-wallet-address-name02 | awk '{print $3}')        
echo FACTOIDWALLETADDRESSKEY02=$FACTOIDWALLETADDRESSKEY02
factom-cli newtransaction setuptransaction
factom-cli addinput setuptransaction $FACTOIDWALLETADDRESSKEY01 150
factom-cli addoutput setuptransaction factoid-wallet-address-name02 149.5
factom-cli sign setuptransaction
factom-cli submit setuptransaction

: <<'EOF1'

EOF1

echo 1.1.1.2 TRY TO CREATE TOO LONG FACTOID WALLET ADDRESS NAME       
factom-cli generateaddress fct factoid-wallet-address-name890123
echo
echo 1.1.1.3 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH '"$"'        
factom-cli generateaddress fct '$F02'
echo 
echo 1.1.1.4 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH '"/"'        
factom-cli generateaddress fct "'/F02'"
echo 
echo 1.1.1.5 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING '"~"'        
factom-cli generateaddress fct "'F~02'"
echo 
echo 1.1.1.6 TRY TO CREATE FACTOID WALLET ADDRESS NAME ENDING WITH '"!"'        
factom-cli generateaddress fct "'F02!'"
echo 
echo 1.1.1.7 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH "@"        
factom-cli generateaddress fct "'@F02'"
echo 
echo 1.1.1.8 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING "#"        
factom-cli generateaddress fct "'F#02'"
echo 
echo 1.1.1.9 TRY TO CREATE FACTOID WALLET ADDRESS NAME ENDING WITH "%"        
factom-cli generateaddress fct "'F02%'"
echo 
echo 1.1.1.10 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH "^"        
factom-cli generateaddress fct "'^F02'"
echo 
echo 1.1.1.11 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING "&"        
factom-cli generateaddress fct "'F&02'"
echo 
echo 1.1.1.12 TRY TO CREATE FACTOID WALLET ADDRESS NAME ENDING WITH "*"        
factom-cli generateaddress fct "'F02*'"
echo 
echo 1.1.1.13 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING "()"        
factom-cli generateaddress fct "'(F02)'"
echo 
echo 1.1.1.14 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH "+"        
factom-cli generateaddress fct "'+F02'"
echo 
echo 1.1.1.15 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING "="        
factom-cli generateaddress fct "'F=02'"
echo 
echo 1.1.1.16 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING "{}"        
factom-cli generateaddress fct "'{F02}'"
echo 
echo 1.1.1.17 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING "[]"        
factom-cli generateaddress fct "'[F02]'"
echo 
echo 1.1.1.18 TRY TO CREATE FACTOID WALLET ADDRESS NAME ENDING WITH "|"        
factom-cli generateaddress fct "'F02|'"
echo 
echo 1.1.1.19 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH ":"        
factom-cli generateaddress fct "':F02'"
echo 
echo 1.1.1.20 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING ";"        
factom-cli generateaddress fct "'F;02'"
echo 
echo 1.1.1.21 TRY TO CREATE FACTOID WALLET ADDRESS NAME ENDING WITH "\""        
factom-cli generateaddress fct "'F02\"'"
echo 
echo 1.1.1.22 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH "'"        
factom-cli generateaddress fct "''F02'"
echo 
echo 1.1.1.23 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING "<"        
factom-cli generateaddress fct "'F<02'"
echo 
echo 1.1.1.24 TRY TO CREATE FACTOID WALLET ADDRESS NAME ENDING WITH ","        
factom-cli generateaddress fct "'F02,'"
echo 
echo 1.1.1.25 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH ">"        
factom-cli generateaddress fct "'>F02'"
echo 
echo 1.1.1.26 TRY TO CREATE FACTOID WALLET ADDRESS NAME CONTAINING "."        
factom-cli generateaddress fct "'F.02'"
echo 
echo 1.1.1.27 TRY TO CREATE FACTOID WALLET ADDRESS NAME ENDING WITH "?"        
factom-cli generateaddress fct "'F02?'"
echo 
echo 1.1.1.28 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH "\\"        
factom-cli generateaddress fct "'\F02'"
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
factom-cli balance fct xxx
echo 
echo 1.1.2.4 REQUEST BALANCE OF FACTOID WALLET ADDRESS NAME TOO LONG
factom-cli balance fct factoid-wallet-address-name890123
echo 
echo 1.1.2.5 REQUEST BALANCE OF FACTOID WALLET ADDRESS WITH NO NAME
factom-cli balance fct 
echo 

echo 1.2 ENTRY CREDIT WALLET        
echo
echo 1.2.1 CREATE ENTRY CREDIT WALLET ADDRESSES
echo
echo 1.2.1.1 CREATE ORDINARY ENTRY CREDIT WALLET ADDRESS NAMES        
ECWALLETADDRESSKEY01=$(factom-cli generateaddress ec ec-wallet-address-name01 | awk '{print $3}')
echo ECWALLETADDRESSKEY01=$ECWALLETADDRESSKEY01
ECWALLETADDRESSKEY02=$(factom-cli generateaddress ec ec-wallet-address-name02 | awk '{print $3}')
echo ECWALLETADDRESSKEY02=$ECWALLETADDRESSKEY02
echo

echo 1.2.1.2 TRY TO CREATE ENTRY CREDIT WALLET ADDRESS NAME STARTING WITH '"$"'        
factom-cli generateaddress ec '$E01'
echo 
echo 1.2.1.3 TRY TO CREATE ENTRY CREDIT WALLET ADDRESS NAME STARTING WITH '"/"'        
factom-cli generateaddress ec "'/E02'"
echo 
echo 1.2.1.4 TRY TO CREATE TOO LONG ENTRY CREDIT WALLET ADDRESS NAME       
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
echo 1.2.2.3 REQUEST ENTRY CREDIT BALANCE OF NON-EXISTENT ENTRY CREDIT WALLET ADDRESS
factom-cli balance ec xxx
echo 
echo 1.2.2.4 REQUEST ENTRY CREDIT BALANCE OF ENTRY CREDIT WALLET ADDRESS NAME TOO LONG
factom-cli balance ec entry-credit-wallet-address-name01
echo
echo 1.2.2.5 REQUEST ENTRY CREDIT BALANCE OF FACTOID WALLET ADDRESS
factom-cli balance ec factoid-wallet-address-name01
echo
echo 1.2.2.6 REQUEST FACTOID BALANCE OF ENTRY CREDIT WALLET ADDRESS
factom-cli balance fct ec-wallet-address-name01
echo

echo 2 TRANSACTIONS        
echo
echo 2.1 TRANSACTION FEE        
factom-cli getfee
echo

echo 2.2 CREATE TRANSACTION WITH NO INPUTS OUTPUTS OR ENTRY CREDITS
echo
echo 2.2.1 CREATE TRANSACTION        
factom-cli newtransaction transaction01
echo
echo 2.2.2 GET TRANSACTION FEE        
factom-cli transactions
echo
echo 2.2.3 SUBMIT UNSIGNED TRANSACTION        
factom-cli submit transaction01
echo
echo 2.2.4 SIGN TRANSACTION        
factom-cli sign transaction01
echo
echo 2.2.5 ADD JUST ENOUGH INPUT TO COVER TRANSACTION FEE        
factom-cli addinput transaction01 factoid-wallet-address-name01 0.05
echo
echo 2.2.6 RE-SIGN TRANSACTION        
factom-cli sign transaction01
echo
echo 2.2.7 TRY TO RECREATE TRANSACTION THAT HASN\'T BEEN ACCEPTED        
factom-cli newtransaction transaction01
echo
echo 2.2.8 GET TRANSACTION FEE        
factom-cli transactions
echo
echo 2.2.9 SUBMIT TRANSACTION        
factom-cli submit transaction01
echo
echo 2.2.10 RECREATE TRANSACTION THAT HAS BEEN ACCEPTED        
factom-cli newtransaction transaction01
echo
echo 2.2.11 ADD INPUT        
factom-cli addinput transaction01 factoid-wallet-address-name01 1
echo
echo 2.2.12 SIGN TRANSACTION        
factom-cli sign transaction01
echo
echo 2.2.13 TRY TO ADD FEE TO TRANSACTION        
factom-cli addfee transaction01 factoid-wallet-address-name01
echo
echo 2.2.14 ADD EQUAL OUTPUT        
factom-cli addoutput transaction01 factoid-wallet-address-name01 1
echo
echo 2.2.15 ADD CORRECT FEE TO TRANSACTION        
factom-cli addfee transaction01 factoid-wallet-address-name01
echo
echo 2.2.16 LIST ALL OPEN TRANSACTIONS         
factom-cli transactions
echo
echo 2.2.17 TRY TO SUBMIT UNSIGNED TRANSACTION        
factom-cli submit transaction01
echo
echo 2.2.18 DELETE TRANSACTION        
factom-cli deletetransaction transaction01
echo
echo 2.2.19 LIST ALL OPEN TRANSACTIONS        
factom-cli transactions
echo
echo 2.2.20 VERIFY WALLET BALANCE        
factom-cli getaddresses
echo

echo 2.3 CREATE TRANSACTION WITH NO INPUTS
echo
echo 2.3.1 CREATE TRANSACTION        
factom-cli newtransaction transaction02
echo
echo 2.3.2 ADD OUTPUT OF 3 FACTOIDS TO TRANSACTION        
factom-cli addoutput transaction02 factoid-wallet-address-name01 3
echo
echo 2.3.3 SIGN TRANSACTION        
factom-cli sign transaction02
echo
echo 2.3.4 GET TRANSACTION FEE        
factom-cli transactions
echo
echo 2.3.5 SUBMIT TRANSACTION        
factom-cli submit transaction02
echo
echo 2.3.6 DELETE TRANSACTION        
factom-cli deletetransaction transaction02
echo
echo 2.3.7 VERIFY WALLET BALANCE        
factom-cli getaddresses
echo

echo 2.4 CREATE TRANSACTION WITH NO OUTPUTS OR ENTRY CREDITS
echo
echo 2.4.1 CREATE TRANSACTION        
factom-cli newtransaction transaction03
echo
echo 2.4.2 ADD INPUT OF 1 FACTOID TO TRANSACTION        
factom-cli addinput transaction03 factoid-wallet-address-name01 0.1
echo
echo 2.4.3 ADD DUPLICATE INPUT OF 1 FACTOID TO TRANSACTION        
factom-cli addinput transaction03 factoid-wallet-address-name01 0.1
echo
echo 2.4.4 SIGN TRANSACTION        
factom-cli sign transaction03
echo
echo 2.4.5 GET TRANSACTION FEE        
factom-cli transactions
echo
echo 2.4.6 SUBMIT TRANSACTION        
factom-cli submit transaction03
echo
echo 2.4.7 VERIFY WALLET BALANCE        
factom-cli getaddresses
echo

echo 2.5 CREATE TRANSACTION WITH INPUT TO ENTRY CREDITS
echo
echo 2.5.1 CREATE TRANSACTION        
factom-cli newtransaction transaction04
echo
echo 2.5.2 ADD INPUT OF 10 FACTOIDS TO TRANSACTION        
factom-cli addinput transaction04 factoid-wallet-address-name01 6.079992
echo
echo 2.5.3 ADD 6 FACTOIDS OF ENTRY CREDITS FOR 1ST ENTRY CREDIT WALLET TO TRANSACTION        
factom-cli addecoutput transaction04 ec-wallet-address-name01 6
echo
echo 2.5.4 ADD -3 FACTOIDS OF ENTRY CREDITS FOR 1ST ENTRY CREDIT WALLET TO TRANSACTION        
factom-cli addecoutput transaction04 ec-wallet-address-name01 -3
echo
echo 2.5.5 SIGN TRANSACTION        
factom-cli sign transaction04
echo
echo 2.5.6 GET TRANSACTION FEE        
factom-cli transactions
echo
echo 2.5.7 SUBMIT TRANSACTION        
factom-cli submit transaction04
echo
echo 2.5.8 VERIFY WALLET BALANCES        
factom-cli getaddresses
echo

echo 2.6 CREATE TRANSACTION WITH INPUT TO OUTPUT
echo
echo 2.6.1 CREATE TRANSACTION        
factom-cli newtransaction transaction05
echo
echo 2.6.2 ADD INPUT OF 10 FACTOIDS TO TRANSACTION        
factom-cli addinput transaction05 factoid-wallet-address-name01 3.07999992
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
echo 2.6.6 GET TRANSACTION FEE        
factom-cli transactions
echo
echo 2.6.7 SUBMIT TRANSACTION        
factom-cli submit transaction05
echo
echo 2.6.8 VERIFY WALLET BALANCE        
factom-cli getaddresses
factom-cli balance fct xxx
echo

echo 2.7 CREATE TRANSACTION WITH INPUT TO OUTPUT AND ENTRY CREDITS        
echo
echo 2.7.1 CREATE TRANSACTION        
factom-cli newtransaction transaction06
echo
echo 2.7.2 ADD INPUT TO TRANSACTION        
echo
echo 2.7.2.1 ADD INPUT OF 10 FACTOIDS TO TRANSACTION        
factom-cli addinput transaction06 factoid-wallet-address-name01 10
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
echo 2.7.6 GET TRANSACTION FEE        
factom-cli transactions
echo
echo 2.7.7 SUBMIT TRANSACTION        
factom-cli submit transaction06
echo
echo 2.7.8 VERIFY WALLET BALANCES        
factom-cli getaddresses
echo
echo 2.7.9 LIST ALL COMPLETED TRANSACTIONS OF FACTOID WALLET ADDRESS         
echo Factoid wallet address = $FACTOIDWALLETADDRESSKEY01
factom-cli list $FACTOIDWALLETADDRESSKEY01
echo

echo 2.8 CREATE TRANSACTION WITH MULTIPLE INPUT OUTPUT AND ENTRY CREDITS        
echo
echo 2.8.1 CREATE TRANSACTION        
factom-cli newtransaction transaction07
echo
echo 2.8.2 ADD INPUTS TO TRANSACTION        
echo
echo 2.8.2.1 ADD 1ST INPUT OF 10 FACTOIDS FROM 1ST FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addinput transaction07 factoid-wallet-address-name01 10
echo
echo 2.8.2.2 ADD 2ND INPUT  OF 30 FACTOIDS FROM 1ST FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addinput transaction07 factoid-wallet-address-name01 30
echo
echo 2.8.2.3 ADD INPUT OF 0.77777779 FACTOIDS FROM 2ND FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addinput transaction07 factoid-wallet-address-name02 0.77777779
echo
echo 2.8.3 ADD OUTPUTS TO TRANSACTION        
echo
echo 2.8.3.1 ADD 1ST OUTPUT OF 4.44444444 FACTOIDS TO 1ST FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addoutput transaction07 factoid-wallet-address-name01 4.44444444
echo
echo 2.8.3.2 ADD 2ND OUTPUT OF 5.55555555 FACTOIDS TO 1ST FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addoutput transaction07 factoid-wallet-address-name01 5.55555555
echo
echo 2.8.3.3 ADD OUTPUT OF 6.66666666 FACTOIDS TO 2ND FACTOID WALLET ADDRESS TO TRANSACTION        
factom-cli addoutput transaction07 factoid-wallet-address-name02 6.66666666
echo
echo 2.8.4 ADD ENTRY CREDIT PURCHASES TO TRANSACTION 
echo
echo 2.8.4.1 ADD 1ST ENTRY CREDIT PURCHASE OF 7 FACTOIDS TO 1ST ENTRY CREDIT WALLET ADDRESS TO TRANSACTION        
factom-cli addecoutput transaction07 $ECWALLETADDRESSKEY01 7
echo
echo 2.8.4.2 ADD 2ND ENTRY CREDIT PURCHASE OF 8 FACTOIDS TO 1ST ENTRY CREDIT WALLET ADDRESS TO TRANSACTION        
factom-cli addecoutput transaction07 $ECWALLETADDRESSKEY01 8
echo
echo 2.8.4.3 ADD 3RD ENTRY CREDIT PURCHASE OF 9 FACTOIDS TO 1ST ENTRY CREDIT WALLET ADDRESS TO TRANSACTION        
factom-cli addecoutput transaction07 $ECWALLETADDRESSKEY02 9
echo
echo 2.8.5 ADD CORRECT FEE TO TRANSACTION        
factom-cli addfee transaction07 factoid-wallet-address-name02
echo
echo 2.8.6 SIGN TRANSACTION        
factom-cli sign transaction07
echo
echo 2.8.7 GET TRANSACTION FEE        
factom-cli transactions
echo
echo 2.8.8 SUBMIT TRANSACTION        
factom-cli submit transaction07
echo
echo 2.8.9 VERIFY WALLET BALANCES        
factom-cli getaddresses
echo

echo 2.9 TEST TRANSACTION PARAMETER LIMITS
echo
echo 2.9.1 ADD INPUT OF -1 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction08
factom-cli addinput transaction08 factoid-wallet-address-name01 -1
factom-cli addoutput transaction08 factoid-wallet-address-name01 -1
factom-cli sign transaction08
factom-cli submit transaction08
factom-cli deletetransaction transaction08
factom-cli getaddresses
echo

echo 2.9.2 ADD INPUT OF 0 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction09
factom-cli addinput transaction09 factoid-wallet-address-name01 0
factom-cli sign transaction09
factom-cli submit transaction09
factom-cli deletetransaction transaction09
factom-cli getaddresses
echo

echo 2.9.3 ADD TOO SMALL INPUT OF 0.000000009 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction10
factom-cli addinput transaction10 factoid-wallet-address-name01 0.000000009
factom-cli sign transaction10
factom-cli submit transaction10
factom-cli deletetransaction transaction10
factom-cli getaddresses
echo

echo 2.9.4 ADD FRACTIONAL INPUT OF FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction11
factom-cli addinput transaction11 factoid-wallet-address-name01 0.07999992
factom-cli sign transaction11
factom-cli submit transaction11
factom-cli getaddresses
echo

echo 2.9.5 ADD FRACTIONAL INPUT OF FACTOIDS WITHOUT LEADING 0 TO TRANSACTION        
factom-cli newtransaction transaction12
factom-cli addinput transaction12 factoid-wallet-address-name01 0.07999992
factom-cli sign transaction12
factom-cli submit transaction12
factom-cli getaddresses
echo

echo 2.9.6 ADD INPUT LARGER THAN FACTOID BALANCE TO TRANSACTION        
factom-cli newtransaction transaction13
factom-cli addinput transaction13 factoid-wallet-address-name01 110
factom-cli addoutput transaction13 factoid-wallet-address-name01 109.9
factom-cli sign transaction13
factom-cli submit transaction13
factom-cli deletetransaction transaction13
factom-cli getaddresses
echo

echo 2.9.7 ADD LARGEST ALLOWABLE INPUT OF 92233720368.54775806 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction14
factom-cli addinput transaction14 factoid-wallet-address-name01 92233720368.54775806
factom-cli addoutput transaction14 factoid-wallet-address-name01 92233720368.4
factom-cli sign transaction14
factom-cli submit transaction14
factom-cli deletetransaction transaction14
factom-cli getaddresses
echo

echo 2.9.8 ADD TOO LARGE INPUT OF 92233720369 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction15
factom-cli addinput transaction15 factoid-wallet-address-name01 92233720369
factom-cli addoutput transaction15 factoid-wallet-address-name01 92233720368.54775806
factom-cli sign transaction15
factom-cli submit transaction15
factom-cli deletetransaction transaction15
factom-cli getaddresses
echo

echo 2.9.9 CREATE LARGEST ALLOWABLE TRANSACTION \(10KB\)        
factom-cli newtransaction transaction16
for ((i=0; i < 76; i++)); do
    factom-cli newtransaction transfertransaction$i
    factom-cli addinput transfertransaction$i factoid-wallet-address-name01 1
    factom-cli generateaddress fct input-address-name$i
    factom-cli addoutput transfertransaction$i input-address-name$i 0.92
    factom-cli sign transfertransaction$i
    factom-cli submit transfertransaction$i
    j=`echo "scale=8;$i/100" | bc`
    factom-cli addinput transaction16 input-address-name$i $j
done
factom-cli sign transaction16
factom-cli submit transaction16
factom-cli getaddresses
echo

echo 2.9.10 TRY TO CREATE TRANSACTION LARGER THAN ALLOWABLE \(\>10KB\)        
factom-cli newtransaction transaction17
factom-cli newtransaction transfertransaction76
factom-cli addinput transfertransaction76 factoid-wallet-address-name01 1
factom-cli generateaddress fct input-address-name76
factom-cli addoutput transfertransaction76 input-address-name76 0.92
factom-cli sign transfertransaction76
factom-cli submit transfertransaction76
for ((i=0; i < 77; i++)); do
    j=`echo "scale=8;$i/100" | bc`
    factom-cli addinput transaction17 input-address-name$i $j
done
factom-cli sign transaction17
factom-cli submit transaction17
factom-cli deletetransaction transaction17
factom-cli getaddresses
echo

echo 3 CHAIN
echo
echo 3.1 MAKE CHAINS
echo
echo 3.1.1 TRY TO MAKE CHAIN USING NON-EXISTENT ENTRY CREDIT ADDRESS
echo
MAKE-CHAIN 1 -e 1 xxx ~/robertubuntu/testing/test-plans-and-scripts/Robert-API/entries/1024-8byte-entry
factom-cli balance ec xxx
echo

echo 3.1.2 TRY TO MAKE CHAIN USING FACTOID WALLET ADDRESS RATHER THAN ENTRY CREDIT WALLET ADDRESS
echo
MAKE-CHAIN 2 -e 2 factoid-wallet-address-name03 ~/robertubuntu/testing/test-plans-and-scripts/Robert-API/entries/1024-8byte-entry
echo

echo 3.1.3 MAKE CHAIN WITH ENTRY \(INCLUDING EXTERNAL IDs\) = 1 byte 
echo Proposed New Chain ID
CHAINID=$(echo 1 | factom-cli mkchain ec-wallet-address-name01 | awk '{print $3}')
echo CHAINID=$CHAINID
GET-ENTRY-BLOCK-CHAIN-HEAD $CHAINID
CHAINIDGOOD=$CHAINID
echo CHAINIDGOOD=$CHAINIDGOOD
HEADGOOD=$HEAD
echo HEADGOOD=$HEADGOOD
echo

for ((i=1024; i < 10241; i+=1024)); do
    j=$(( i/1024-1 ))
    echo 3.1.$((j*2+4)) ADD ENTRY $i BYTES \(INCLUDING EXTERNAL IDs\) TO CHAIN
    factom-cli mkchain -e 0$j -e 0$j ec-wallet-address-name01 <~/robertubuntu/testing/test-plans-and-scripts/Robert-API/entries/$i-8byte-entry 
    factom-cli getaddresses
    echo 3.1.$((j*2+5)) ADD ENTRY $((i+1)) bytes \(INCLUDING EXTERNAL IDs\) TO CHAIN
    factom-cli mkchain -e 01$j -e 1$j ec-wallet-address-name01 <~/robertubuntu/testing/test-plans-and-scripts/Robert-API/entries/$i-8byte-entry 
    factom-cli getaddresses
   echo
done
echo 

echo 3.1.24 MAKE CHAIN THAT ALREADY EXISTS
echo
echo 2 | factom-cli mkchain ec-wallet-address-name01
factom-cli getaddresses
echo

echo 3.1.25 TRY TO MAKE SAME CHAIN USING DIFFERENT INITIAL ENTRY
factom-cli mkchain $ECWALLETADDRESSKEY01 <~/robertubuntu/testing/test-plans-and-scripts/Robert-API/entries/1024-8byte-entry
factom-cli getaddresses
echo

echo 3.2 ENTRY BLOCK CHAIN
echo
echo 3.2.1 SHOW ENTRY BLOCK CHAIN
echo
TRACE-ENTRY-BLOCK-CHAIN $HEADGOOD

echo 3.2.2 TRY TO ADD ENTRY TO CHAIN USING FACTOID WALLET ADDRESS RATHER THAN ENTRY CREDIT WALLET ADDRESS
echo 3.2.2.1 ADD ENTRY TO CHAIN
factom-cli put -e 05 -e 05 -c $CHAINIDGOOD $FACTOIDWALLETADDRESSKEY01 <~/robertubuntu/testing/test-plans-and-scripts/Robert-API/entries/1024-8byte-entry
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
factom-cli getaddresses
echo
echo 3.2.2.2 TRACE ENTRY BLOCK CHAIN
TRACE-UPDATED-ENTRY-BLOCK-CHAIN

echo 3.2.3 MAKE ENTRY \(INCLUDING EXTERNAL IDs\) = 1 byte
echo 3 | factom-cli put -e 06 -e 06 -c $CHAINIDGOOD ec-wallet-address-name01 
factom-cli getaddresses
echo

for ((i=1024; i < 10241; i+=1024)); do
    j=$(( i/1024-1 ))
    echo 3.2.$((j*2+4)) "ADD ENTRY" $i "bytes \(INCLUDING EXTERNAL IDs\) TO CHAIN"
    factom-cli put -e 0$j -e 0$j -c $CHAINIDGOOD ec-wallet-address-name01 <~/robertubuntu/testing/test-plans-and-scripts/Robert-API/entries/$i"-8byte-entry" 
    factom-cli getaddresses
    echo 3.2.$((j*2+5)) "ADD ENTRY" $((i+1)) "bytes \(INCLUDING EXTERNAL IDs\) TO CHAIN"
    factom-cli put -e 01$j -e 0$j -c $CHAINIDGOOD ec-wallet-address-name01 <~/robertubuntu/testing/test-plans-and-scripts/Robert-API/entries/$i"-8byte-entry" 
    factom-cli getaddresses
   echo
done
echo 

echo 3.2.24 TRACE ENTRY BLOCK CHAIN
TRACE-UPDATED-ENTRY-BLOCK-CHAIN

: <<'EOF1'

echo 3.2.25 MAKE MANY ENTRIES
echo
echo 3.2.4.1 ACQUIRE MANY ENTRY CREDITS
factom-cli newtransaction transfertransaction01
factom-cli addinput transfertransaction01 dummy4 200
factom-cli addecoutput transfertransaction01 ec-wallet-address-name01 199
factom-cli sign transfertransaction01
factom-cli submit transfertransaction01
factom-cli getaddresses
echo

EOF1

echo 3.2.25 CREATE 10 ENTRIES
for ((i=1; i < 11; i++)); do
    echo $i | factom-cli put -e $i -c $CHAINIDGOOD ec-wallet-address-name01 &
    sleep 1
done
echo

echo 3.2.26 TRACE ENTRY BLOCK CHAIN
TRACE-UPDATED-ENTRY-BLOCK-CHAIN

echo 3.2.26.1 CHECK THAT ENTRY CREDIT TIMESTAMPS ARE DIFFERENT FROM ENTRY BLOCK TIMESTAMP

: <<'EOF'

for ((i=1; i < 41; i++)); do
    for ((j=1; j < 501; j++)); do
    echo $i $j | factom-cli put -c $CHAINIDGOOD -e $i -e $j ec-wallet-address-name02 &
    done
echo $i of 40 groups of 500 finished
sleep 1
done

EOF

echo 3.3 DIRECTORY BLOCK CHAIN
echo
echo 3.3.1 TRACE DIRECTORY BLOCK CHAIN
#'s/[{}]//g'  | sed 's/^.//'  | sed 's/.$//'
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

echo 4 SYSTEM
echo
echo 4.1 SYSTEM PROPERTIES
factom-cli properties
echo
echo 4.2 LIST ALL COMPLETED TRANSACTIONS IN SYSTEM         
factom-cli list all
echo







