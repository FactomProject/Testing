#!/bin/bash

echo 1	WALLET
echo 1.1	DEFAULT WALLET
echo 1.1.1	SETTING UP DEFAULT WALLET
factom-cli eckey new >~/.factom/ecwallet
cat ~/.factom/ecwallet
factom-cli eckey pub

echo 1.1.2	ADDING TEST CREDITS TO DEFAULT WALLET
factom-cli balance ec
factom-cli testcredit
factom-cli balance ec

echo "1.2	NON-DEFAULT WALLET"
echo "1.2.1	SETTING UP NON-DEFAULT WALLET"
factom-cli eckey new >~/testing/ecwallet
cat ~/testing/ecwallet
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

