#!/bin/bash

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



