#!/bin/bash +x

echo WAITING 60 SECONDS FOR FACTOMD TO INITIALIZE
sleep 60
echo
echo 1 WALLETS
echo
echo 1.1 FACTOID WALLET
echo
echo 1.1.1 CREATE FACTOID WALLET ADDRESSES        
echo
echo 1.1.1.1 CREATE LEGITIMATE FACTOID WALLET ADDRESSES CONTAINING 2000 FACTOIDS        
for ((i=1; i < 11; i++)); do factom-cli generateaddress fct dummy$i; done
for ((i=1; i < 4; i++)); do
    tmpkey="FACTOIDWALLETADDRESSKEY0$i"
    tmpname="factoid-wallet-address-name0$i"
    declare $tmpkey=$(factom-cli generateaddress fct $tmpname | awk '{print $3}')
    echo "factoid-wallet-address-name0$i = "${!tmpkey}
    factom-cli newtransaction dummytransaction$i
    factom-cli addinput dummytransaction$i dummy$i 2001
    factom-cli addoutput dummytransaction$i factoid-wallet-address-name0$i 2000
    factom-cli sign dummytransaction$i
    factom-cli submit dummytransaction$i
    factom-cli balance fct factoid-wallet-address-name0$i
done
echo 
echo 1.1.1.2 TRY TO CREATE TOO LONG FACTOID WALLET ADDRESS NAME       
factom-cli generateaddress fct factoid-wallet-address-name890123
echo
echo 1.1.1.3 TRY TO CREATE FACTOID WALLET ADDRESS NAME STARTING WITH '"$"'        
factom-cli generateaddress fct '$F01'
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
factom-cli balance fct factoid-wallet-address-name0$i
    TMP="FACTOIDWALLETADDRESSKEY0$i" 
 factom-cli balance fct $FACTOIDWALLETADDRESSKEY01
factom-cli balance fct factoid-wallet-address-name02
factom-cli balance fct $FACTOIDWALLETADDRESSKEY02
factom-cli balance fct factoid-wallet-address-name03
factom-cli balance fct $FACTOIDWALLETADDRESSKEY03
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
echo 1.2.2.3 REQUEST BALANCE OF NON-EXISTENT ENTRY CREDIT WALLET ADDRESS
factom-cli balance ec xxx
echo 
echo 1.2.2.4 REQUEST BALANCE OF ENTRY CREDIT WALLET ADDRESS NAME TOO LONG
factom-cli balance ec hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhaaaa
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
echo 2.2.2 SUBMIT TRANSACTION        
factom-cli submit transaction01
echo
echo 2.2.3 SIGN TRANSACTION        
factom-cli sign transaction01
echo
echo 2.2.4 ADD JUST ENOUGH INPUT TO COVER TRANSACTION FEE        
factom-cli addinput transaction01 factoid-wallet-address-name01 1
echo
echo 2.2.5 RE-SIGN TRANSACTION        
factom-cli sign transaction01
echo
echo 2.2.6 TRY TO RECREATE TRANSACTION THAT HASN\'T BEEN ACCEPTED        
factom-cli newtransaction transaction01
echo
echo 2.2.7 SUBMIT TRANSACTION        
factom-cli submit transaction01
echo
echo 2.2.8 TRY TO RECREATE TRANSACTION THAT HAS BEEN ACCEPTED        
factom-cli newtransaction transaction01
echo
echo 2.2.9 VERIFY WALLET BALANCE        
factom-cli balance fct factoid-wallet-address-name01
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
echo 2.3.4 SUBMIT TRANSACTION        
factom-cli submit transaction02
echo
echo 2.3.5 VERIFY WALLET BALANCE        
factom-cli balance fct factoid-wallet-address-name01
echo

echo 2.4 CREATE TRANSACTION WITH NO OUTPUTS OR ENTRY CREDITS
echo
echo 2.4.1 CREATE TRANSACTION        
factom-cli newtransaction transaction03
echo
echo 2.4.2 ADD INPUT OF 100 FACTOIDS TO TRANSACTION        
factom-cli addinput transaction03 factoid-wallet-address-name01 100
echo
echo 2.4.3 ADD DUPLICATE INPUT OF 100 FACTOIDS TO TRANSACTION        
factom-cli addinput transaction03 factoid-wallet-address-name01 100
echo
echo 2.4.4 SIGN TRANSACTION        
factom-cli sign transaction03
echo
echo 2.4.5 SUBMIT TRANSACTION        
factom-cli submit transaction03
echo
echo 2.4.6 VERIFY WALLET BALANCE        
factom-cli balance fct factoid-wallet-address-name01
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
echo 2.5.4 ADD -3 FACTOIDS OF ENTRY CREDITS FOR 1ST ENTRY CREDIT WALLET TO TRANSACTION        
factom-cli addecoutput transaction04 ec-wallet-address-name01 -3
echo
echo 2.5.5 SIGN TRANSACTION        
factom-cli sign transaction04
echo
echo 2.5.6 SUBMIT TRANSACTION        
factom-cli submit transaction04
echo
echo 2.5.7 VERIFY WALLET BALANCES        
factom-cli balance fct factoid-wallet-address-name01
factom-cli balance ec ec-wallet-address-name01
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
echo 2.6.7 VERIFY WALLET BALANCE        
factom-cli balance fct factoid-wallet-address-name01
factom-cli balance fct xxx
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
factom-cli balance fct factoid-wallet-address-name01
factom-cli balance fct factoid-wallet-address-name02
factom-cli balance ec $ECWALLETADDRESSKEY01
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
factom-cli transactions
echo
echo 2.8.6 SIGN TRANSACTION        
factom-cli sign transaction07
echo
echo 2.8.7 SUBMIT TRANSACTION        
factom-cli submit transaction07
echo
echo 2.8.8 VERIFY WALLET BALANCES        
factom-cli balance fct factoid-wallet-address-name01
factom-cli balance fct factoid-wallet-address-name02
factom-cli balance ec $ECWALLETADDRESSKEY01
factom-cli balance ec $ECWALLETADDRESSKEY02
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
factom-cli balance fct factoid-wallet-address-name03
factom-cli newtransaction transaction09
factom-cli addinput transaction09 factoid-wallet-address-name03 0
factom-cli sign transaction09
factom-cli submit transaction09
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.3 ADD TOO SMALL INPUT OF 0.000000009 FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction10
factom-cli addinput transaction10 factoid-wallet-address-name03 0.000000009
factom-cli sign transaction10
factom-cli submit transaction10
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.4 ADD FRACTIONAL INPUT OF FACTOIDS TO TRANSACTION        
factom-cli newtransaction transaction11
factom-cli addinput transaction11 factoid-wallet-address-name03 0.5
factom-cli sign transaction11
factom-cli submit transaction11
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.5 ADD FRACTIONAL INPUT OF FACTOIDS WITHOUT LEADING 0 TO TRANSACTION        
factom-cli newtransaction transaction12
factom-cli addinput transaction12 factoid-wallet-address-name03 .5
factom-cli sign transaction12
factom-cli submit transaction12
factom-cli balance fct factoid-wallet-address-name03
echo

echo 2.9.6 ADD INPUT LARGER THAN FACTOID BALANCE TO TRANSACTION        
factom-cli newtransaction transaction13
factom-cli addinput transaction13 factoid-wallet-address-name01 21000
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

echo 2.9.9 CREATE LARGEST ALLOWABLE TRANSACTION \(10KB\)        
factom-cli newtransaction transaction16
for ((i=0; i < 76; i++)); do
    factom-cli newtransaction transfertransaction$i
    factom-cli addinput transfertransaction$i dummy0 2
    factom-cli generateaddress fct input-address-name$i
    factom-cli addoutput transfertransaction$i input-address-name$i 1.9
    factom-cli sign transfertransaction$i
    factom-cli submit transfertransaction$i
    j=`echo "scale=8;$i/100" | bc`
    factom-cli addinput transaction16 input-address-name$i $j
done
factom-cli sign transaction16
factom-cli submit transaction16
echo

echo 2.9.10 TRY TO CREATE TRANSACTION LARGER THAN ALLOWABLE \(\>10KB\)        
factom-cli newtransaction transaction17
factom-cli newtransaction transfertransaction76
factom-cli addinput transfertransaction76 dummy0 2
factom-cli generateaddress fct input-address-name76
factom-cli addoutput transfertransaction76 input-address-name76 1.9
factom-cli sign transfertransaction76
factom-cli submit transfertransaction76
for ((i=0; i < 77; i++)); do
    j=`echo "scale=8;$i/100" | bc`
    factom-cli addinput transaction17 input-address-name$i $j
done
factom-cli sign transaction17
factom-cli submit transaction17
echo

echo 3 CHAIN
echo
echo 3.1 MAKE CHAINS
echo
echo 3.1.1 TRY TO MAKE CHAIN USING NON-EXISTENT ENTRY CREDIT ADDRESS
echo
echo Proposed New Chain ID
CHAINID=$(factom-cli mkchain -e 1 -e 1 xxx <~/testing/testing/test-plans-and-scripts/Robert-API/entries/small-entry | awk '{print $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
echo Chain Head Merkelroot
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec xxx
echo

echo 3.1.2 TRY TO MAKE CHAIN USING FACTOID WALLET ADDRESS RATHER THAN ENTRY CREDIT WALLET ADDRESS
echo
factom-cli balance fct factoid-wallet-address-name03
echo Proposed New Chain ID
CHAINID=$(factom-cli mkchain -e 2 -e 2 factoid-wallet-address-name03 <~/testing/testing/test-plans-and-scripts/Robert-API/entries/small-entry | awk '{printf $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
echo Chain Head Merkelroot
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance fct factoid-wallet-address-name03
echo

echo 3.1.3 MAKE CHAIN WITH SMALL ENTRY
echo
factom-cli balance ec ec-wallet-address-name01
echo Proposed New Chain ID
CHAINIDGOOD=$(factom-cli mkchain -e 3 -e 3 ec-wallet-address-name01 <~/testing/testing/test-plans-and-scripts/Robert-API/entries/small-entry | awk '{printf $3}')
echo $CHAINIDGOOD
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
echo Chain Head Merkelroot
HEADGOOD=$(factom-cli get chain $CHAINIDGOOD)
echo $HEADGOOD
factom-cli balance ec ec-wallet-address-name01
echo

echo 3.1.4 MAKE CHAIN WITH ENTRY \(INCLUDING EXTERNAL ID\) SIZE OF 10202 BYTES
echo
echo Proposed New Chain ID
CHAINID=$(factom-cli mkchain -e 4 -e 4 $ECWALLETADDRESSKEY01 <~/testing/testing/test-plans-and-scripts/Robert-API/entries/big-entry | awk '{printf $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
echo Chain Head Merkelroot
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec $ECWALLETADDRESSKEY01
echo

echo 3.1.5 MAKE CHAIN WITH MAXIMUM ENTRY \(INCLUDING EXTERNAL ID\) SIZE \(10240 BYTES\)
echo
echo Proposed New Chain ID
CHAINID=$(factom-cli mkchain -e 12345678901234567890 -e 12345678901234567890 ec-wallet-address-name01 <~/testing/testing/test-plans-and-scripts/Robert-API/entries/big-entry | awk '{printf $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
echo Chain Head Merkelroot
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec ec-wallet-address-name01
echo

echo 3.1.6 TRY TO MAKE CHAIN WITH ENTRY \(INCLUDING EXTERNAL ID\) SIZE \>10240 BYTES
echo
echo Proposed New Chain ID
CHAINID=$(factom-cli mkchain -e 123456789012345678901 -e 12345678901234567890 $ECWALLETADDRESSKEY01 <~/testing/testing/test-plans-and-scripts/Robert-API/entries/big-entry | awk '{printf $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
echo Chain Head Merkelroot
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec $ECWALLETADDRESSKEY01
echo

echo 3.1.7 MAKE CHAIN THAT ALREADY EXISTS
echo
echo Proposed New Chain ID
CHAINID=$(factom-cli mkchain -e 3 -e 3 ec-wallet-address-name01 <~/testing/testing/test-plans-and-scripts/Robert-API/entries/small-entry | awk '{printf $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
echo Chain Head Merkelroot
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec ec-wallet-address-name01
echo

echo 3.1.8 TRY TO MAKE SAME CHAIN USING DIFFERENT INITIAL ENTRY
echo
echo Proposed New Chain ID
CHAINID=$(factom-cli mkchain -e 3 -e 3 $ECWALLETADDRESSKEY01 <~/testing/testing/test-plans-and-scripts/Robert-API/entries/big-entry | awk '{printf $3}')
echo $CHAINID
echo
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
echo Chain Head Merkelroot
HEAD=$(factom-cli get chain $CHAINID)
echo $HEAD
factom-cli balance ec $ECWALLETADDRESSKEY01
echo

echo 3.2 ENTRY BLOCK CHAIN
echo
echo 3.2.1 SHOW ENTRY BLOCK CHAIN
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

echo 3.2.2 TRY TO ADD ENTRY TO CHAIN USING FACTOID WALLET ADDRESS RATHER THAN ENTRY CREDIT WALLET ADDRESS
echo 3.2.2.1 ADD ENTRY TO CHAIN
factom-cli balance fct $FACTOIDWALLETADDRESSKEY03
factom-cli put -e 5 -e 5 -c $CHAINIDGOOD $FACTOIDWALLETADDRESSKEY03 <~/testing/testing/test-plans-and-scripts/Robert-API/entries/small-entry
echo Chain Head Merkelroot
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
HEAD=$(factom-cli get chain $CHAINIDGOOD)
echo $HEAD
factom-cli balance fct $FACTOIDWALLETADDRESSKEY03
echo

echo 3.2.2.2 TRACE ENTRY BLOCK CHAIN
ENTRYKEYMERKELROOT=$HEAD
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

echo 3.2.3 ADD ENTRY TO CHAIN USING ENTRY CREDIT WALLET ADDRESS
echo 3.2.3.1 ADD ENTRY TO CHAIN
factom-cli balance ec ec-wallet-address-name01
factom-cli put -e 6 -e 6 -c $CHAINIDGOOD ec-wallet-address-name01 <~/testing/testing/test-plans-and-scripts/Robert-API/entries/another-small-entry
echo Chain Head Merkelroot
echo WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE
sleep 60
HEADGOOD=$(factom-cli get chain $CHAINIDGOOD)
echo $HEADGOOD
factom-cli balance ec ec-wallet-address-name01
echo

echo 3.2.3.2 TRACE ENTRY BLOCK CHAIN
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

echo 3.2.4 MAKE MANY ENTRIES
echo
echo 3.2.4.1 ACQUIRE MANY ENTRY CREDITS
factom-cli balance ec ec-wallet-address-name01
factom-cli newtransaction transaction18
factom-cli addinput transfertransaction18 dummy4 200
factom-cli addecoutput transfertransaction18 ec-wallet-address-name01 199
factom-cli sign transfertransaction18
factom-cli submit transfertransaction18
factom-cli balance ec ec-wallet-address-name01
echo
echo 3.2.4.2 CREATE 10 ENTRIES
for ((i=0; i < 10; i++)); do
    echo $i | factom-cli put -c $CHAINIDGOOD -e $i ec-wallet-address-name01 &
    sleep 1
done
echo
echo 3.2.4.3 CHECK THAT ENTRY CREDIT TIMESTAMPS ARE DIFFERENT FROM ENTRY BLOCK TIMESTAMP AND FROM EACH OTHER
sleep 60
HEADGOOD=$(factom-cli get chain $CHAINIDGOOD)
echo $HEADGOOD
echo
echo 3.2.3.2 TRACE ENTRY BLOCK CHAIN
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
echo


: <<'EOF'

for ((i=0; i < 100; i++)); do
    for ((j=0; j < 500; j++)); do
    echo $i $j | factom-cli put -c $CHAINIDGOOD -e $i -e $j dummy5 &
    done
echo $(($i+1)) of 100 groups of 500 finished
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









