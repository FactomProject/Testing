How to Write data into Factom
==========


This document is a walk through on how to use the python scripts to add data into Factom.

It uses the scripts [writeFactomChainAPI.py](writeFactomChainAPI.py) and [writeFactomEntryAPI.py](writeFactomEntryAPI.py) along with `factomd` to show how other programs can access the factomd API. 

The intent is for the python programs to be examples, and additionally could be modified and pulled into client software.

These directions have you modify the python scripts in order to have a non-shared private key.



### Install Python

Install python on your local machine.

It should be available on Linux and Mac, but needs to be installed on windows. Python v 2.7 works fine for these directions.

On Windows, download and install python 2.7.x. https://www.python.org/downloads/

Make sure you enable "Add python.exe to Path" during the windows install.

To test if it is installed, in a terminal window, type `python -V` and it should give an answer.


### Configure Python


##### Linux
On Ubuntu run these commands to install prerequisites:

```
sudo apt-get install python-pip
sudo apt-get install python-dev
sudo pip install ed25519
sudo pip install base58
```


##### Windows

- Download and install "Microsoft Visual C++ Compiler for Python 2.7" http://aka.ms/vcpython27

- In a terminal window run:

```
pip install ed25519
pip install base58
```


### Install Factom Binaries

Directions are available here:
http://factom.org/howto

Binaries are located here:
[Linux](http://factom.org/downloads/factom.deb)
[Windows](http://factom.org/downloads/factom.msi)
[Mac](http://factom.org/downloads/factom.mpkg.zip)



Alternatively, you can install from the Factom source code.  Directions [here](https://github.com/FactomProject/FactomDocs/blob/master/communityTesterDirections.md).  If installing from source, also move the `~/go/src/github.com/FactomProject/walletapp/staticfiles`directory to `/usr/share/factom/walletapp/` on Linux and `C:\Program Files\Factom\staticfiles` in Windows.


In a terminal window run factomd.  It should look like this:

![factomd](/images/factomd.png)

Wait for the blockchain to download and validate. It should only take a few minutes depending on your internet speed.

To check progress, check the directory `$HOME\.factom\store\seed\000000000000000000000000000000000000000000000000000000000000000d`.  The number of files in this directory are the number of blocks downloaded to your local machine.

There are some reports that downloading the blockchain may stall when initially syncing with fast internet connectivity after a few hundred blocks. Restarting factomd fixes the problem.

### Setup the Scripts

Download [writeFactomChainAPI.py](writeFactomChainAPI.py) and [writeFactomEntryAPI.py](writeFactomEntryAPI.py) to a folder.  This example will use the folder `factom_py_examples`.

Get 32 bytes of randomness, so that you are not sharing private keys with others (to avoid mysterious problems).  Here is a source of random numbers: https://www.random.org/cgi-bin/randbyte?nbytes=32&format=h

Record these 32 bytes, so they can be used later.

Open both writeFactomChainAPI.py and writeFactomEntryAPI.py in a text editor and replace the 64 zeros after `privateECKey = ` with the random number.  Remove spaces and line returns from the random number.

![newECkey](/images/newECkey.png)


Next, open a terminal and navigate to the `factom_py_examples` directory. run `python writeFactomEntryAPI.py`:

```
$ python writeFactomEntryAPI.py 

Add Entry Credits to this key: EC2GYjva8KqHC5x39mXnY7fcRCHsCnvuMNF1W9aDGUYj4ihgvf9H
It currently has a balance of 0
```

It shows you the Entry Credit public key the random number corresponds to and the number of Entry Credits currently assigned to it.

### Turn Factoids into Entry Credits

First you need to acquire some Factoids.

- Run `walletapp`.  This should have been installed with factomd. It will open a web browser showing the GUI wallet.  Make sure factomd is also running when you run walletapp.

![newECkey](/images/guiwallet1.png)

- Create a new Factoid address

![newECkey](/images/guiwallet2.png)

- Give the address and name.  Refresh the webpage.

- Have someone send Factoids to the new address.  In this example the address is FA34cEZvWHMTQZfLshqwz47USjJRyEB1VqABjQEL9z4RuA8b2NM8

![newECkey](/images/guiwallet3.png)

- Wait for the Factoids to be sent to your wallet. Factoid transaction are confirmed every 10 minutes on the 10 minute mark.  Refresh the webpage to see if Factoids have been confirmed.

- Once you have Factoids in the GUI wallet, you can turn them into Entry Credits. 

![newECkey](/images/guiwallet4.png)

1. input the address in your wallet that has Factoids
2. put in the number of Factoids you want to spend
3. add the EC address from the script output
4. **Put the same amount here as above.**  In this example, I typed 0.5 into this field
5. Clicking the -FEE button lowers the number of ECs purchased by the fee amount.  This example subtracted 0.02232 Factoids from the output.
6. Sign the transaction to authorize it.
7. Submit the transaction to the local factomd client, which will submit it to the network.  This is what a successful transaction looks like:

![newECkey](/images/guiwallet5.png)

- The transaction should confirm after 10 minutes.  At this point, you have Entry Credits.

- walletapp can be closed at this point, but leave factomd running.


### Make a new Chain

Chains are the way users can mostly keep their data separate from each other. It is recommended that new Chains are made for new applications.

Chains are identified by a ChainID, which is a hash of the Chain Name. Applications should come up with a new Chain Name.


- Open writeFactomChainAPI.py in a text editor and change some of the text after `chainName = `

![newECkey](/images/newChainName.png)

- Run `python writeFactomChainAPI.py`

```
$ python writeFactomChainAPI.py 

Add Entry Credits to this key: EC2GYjva8KqHC5x39mXnY7fcRCHsCnvuMNF1W9aDGUYj4ihgvf9H
It currently has a balance of 256

Writing to the Factom API
requiring this many EC: 11
entry is this many bytes: 119
commit gives status: 200
reveal gives status: 200
made chain e5c1f2d9ee0686b3ec28621248c0d049ffd14894cf72da1884bbb2cc7d37ff44
wrote entry with hash 75c1de1a2d438b3fc491c67bca8d0f61b015473272ac2fbff9cbc35bb2f2fd53
```

We can see after 10 minutes that a new chain has been made:

![newECkey](/images/newChainNameMade.png)

http://explorer.factom.org/chain/e5c1f2d9ee0686b3ec28621248c0d049ffd14894cf72da1884bbb2cc7d37ff44

The Chain Name hashed to e5c1f2d9ee0686b3ec28621248c0d049ffd14894cf72da1884bbb2cc7d37ff44, which is now our ChainID.

### Make a new Entry

Now that we have our new ChainID, we can place Entries into it.

- Open writeFactomEntryAPI.py in a text editor and put your custom ChainID from above after `chainID =`

![newECkey](/images/newEntry1.png)

- Edit the data in entryContent and externalIDs to suit your application. This is where the important data you are protecting by Factom goes.  External IDs are not needed, and can be blank, but provide some semi-defined structure within an Entry.

- Run `python writeFactomEntryAPI.py`

```
$ python writeFactomEntryAPI.py 

Add Entry Credits to this key: EC2GYjva8KqHC5x39mXnY7fcRCHsCnvuMNF1W9aDGUYj4ihgvf9H
It currently has a balance of 245

Writing to the Factom API
commit gives status: 200
reveal gives status: 200
wrote 1e59263fe535da22033a368de4ab6307ca376f5f8ec731d0e04640a260b8b144
hello world
```

- The same Entry can be placed into the blockchain multiple times.

- After 10 minutes the Entry will be confirmed in the next block.  The example Entry has the hash of 1e59263fe535da22033a368de4ab6307ca376f5f8ec731d0e04640a260b8b144

http://explorer.factom.org/entry/1e59263fe535da22033a368de4ab6307ca376f5f8ec731d0e04640a260b8b144


The Entries can also be observed with factom-cli

```
$ factom-cli get chain e5c1f2d9ee0686b3ec28621248c0d049ffd14894cf72da1884bbb2cc7d37ff44
ab44d4cd67b9643704c3a9ce97b17888114b9741153d802a53553e4df066f3ee
```

```
$ factom-cli get eblock ab44d4cd67b9643704c3a9ce97b17888114b9741153d802a53553e4df066f3ee
BlockSequenceNumber: 1
ChainID: e5c1f2d9ee0686b3ec28621248c0d049ffd14894cf72da1884bbb2cc7d37ff44
PrevKeyMR: f4fe39db71ae60c28699a6c2d2f87c0d242e829c9522d649ec586c8585d749c2
Timestamp: 1451452800
EBEntry {
	Timestamp 1451452980
	EntryHash 1e59263fe535da22033a368de4ab6307ca376f5f8ec731d0e04640a260b8b144
}
```

```
$ factom-cli get entry 1e59263fe535da22033a368de4ab6307ca376f5f8ec731d0e04640a260b8b144
ChainID: e5c1f2d9ee0686b3ec28621248c0d049ffd14894cf72da1884bbb2cc7d37ff44
ExtID: extid
ExtID: anotherextid
Content:
hello world
```

Congratulations you have placed data into Factom.


Also see the code [findChainNames.py](findChainNames.py) to see how to programmatically read the blockchain.




