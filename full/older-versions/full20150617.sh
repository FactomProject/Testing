#!/bin/bash

echo 1	WALLET
echo 1.1	DEFAULT WALLET
echo 1.1.1	SETTING UP DEFAULT WALLET
factom-cli eckey new >~/.factom/ecwallet
cat ~/.factom/ecwallet
echo ""
factom-cli eckey pub

echo 1.1.2	ADDING TEST CREDITS TO DEFAULT WALLET
factom-cli balance ec
factom-cli testcredit
factom-cli balance ec

echo "1.2	NON-DEFAULT WALLET"
echo "1.2.1	SETTING UP NON-DEFAULT WALLET"
factom-cli eckey new >~/testing/ecwallet
cat ~/testing/ecwallet
echo ""
factom-cli -w ~/testing/ecwallet eckey pub

echo "1.2.2	ADDING TEST CREDITS TO NON-DEFAULT WALLET"
factom-cli -w ~/testing/ecwallet balance ec
factom-cli -w ~/testing/ecwallet testcredit
factom-cli -w ~/testing/ecwallet balance ec

echo "1.3	ADDING TEST CREDITS TO NON-EXISTENT WALLET"
factom-cli -w ~/testing/tex.bin balance ec
factom-cli -w ~/testing/tex.bin testcredit
factom-cli -w ~/testing/tex.bin balance ec

echo "1.4	ADDING TEST CREDITS TO NON-WALLET FILE"
factom-cli -w ~/testing/non-wallet-file balance ec
factom-cli -w ~/testing/non-wallet-file testcredit
factom-cli -w ~/testing/non-wallet-file balance ec

echo "2	BUY ENTRY CREDITS"
echo "2.1	BUY 100 ENTRY CREDITS"
factom-cli -w ~/testing/ecwallet balance ec
factom-cli -w ~/testing/ecwallet buy #100
factom-cli -w ~/testing/ecwallet balance ec

echo "2.2	BUY -100 ENTRY CREDITS"
factom-cli -w ~/testing/ecwallet balance ec
factom-cli -w ~/testing/ecwallet buy #-100
factom-cli -w ~/testing/ecwallet balance ec

echo "2.3	BUY 0 ENTRY CREDITS"
factom-cli -w ~/testing/ecwallet balance ec
factom-cli -w ~/testing/ecwallet buy #0
factom-cli -w ~/testing/ecwallet balance ec

echo "2.4	BUY 5a5 ENTRY CREDITS"
factom-cli -w ~/testing/ecwallet balance ec
factom-cli -w ~/testing/ecwallet buy #5a5
factom-cli -w ~/testing/ecwallet balance ec

echo "2.5	BUY A GAZILLION ENTRY CREDITS"
factom-cli -w ~/testing/ecwallet balance ec
factom-cli -w ~/testing/ecwallet buy #5000000000
factom-cli -w ~/testing/ecwallet balance ec

echo "3	CHAIN"
echo "3.1	MAKE A CHAIN"
CHAINID=$(factom-cli mkchain -e level1 -e level2 <~/testing/test-plans-and-scripts/chain/1st-entry)
echo $CHAINID
echo "WAITING 60 SECONDS FOR DIRECTORY BLOCK TO CLOSE"
sleep 60

echo "3.2	TRACE  CHAIN"
DIRECTORYKEYMERKELROOT=$(factom-cli get head)
echo $DIRECTORYKEYMERKELROOT
until [ $DIRECTORYKEYMERKELROOT -eq         "0000000000000000000000000000000000000000000000000000000000000000" ]; do
	DIRECTORYKEYMERKELROOT=$(factom-cli get dblock $DIRECTORYKEYMERKELROOT)
	echo $DIRECTORYKEYMERKELROOT
done

echo "4	ENTRY"
echo "4.1	PUT ENTRY"
factom-cli put -e 1level1 -e 1level2 -c $CHAINID <~/testing/test-plans-and-scripts/entry/another-entry




