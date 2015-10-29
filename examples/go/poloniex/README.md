Factom Poloniex Price Monitor
==========


### Prepare Operating System

The most testing to date has been done under Linux. To get the best testing experience, it should be done on Linux. That will also help us recreate the bugs you experience better. If you are running Windows, please install a virtual machine to run Factom. On a Mac, the only differences are with installing Hg and Git.  Installing on Windows has been known to work, but is not covered here.

[Here are some good directions to get a virtual machine installed with Linux.](http://www.instructables.com/id/Introduction-38/?ALLSTEPS) 

The following are assuming you are using the 64 bit version of Ubuntu, or one of its descendant projects like xubuntu or mint.

#### Install the go language and dependencies, then setup GOPATH

###### Install Package Managers 

In a terminal window, install Git and Mercurial

On Linux:
```
sudo apt-get install git mercurial
```

On Mac:
Steps 1 and 3 should be enough in [this tutuorial](https://confluence.atlassian.com/pages/viewpage.action?pageId=269981802).

###### Install Golang

Download [the latest version of go](https://golang.org/dl/).  This example uses 64 bit Linux and 1.5.1 is the latest version.
```
sudo tar -C /usr/local -xzf go1.5.1.linux-amd64.tar.gz
```

On Mac, [installing go this way](http://www.cyberciti.biz/faq/installing-go-programming-language-on-mac-os-x/) should work.


###### Setup Paths

Put the go binary directory in you path.
Open the file `~/.profile` and add these lines to the bottom.  If they are not exact, then your Linux may not be bootable.
```
export PATH=$PATH:/usr/local/go/bin
```
Now setup GOPATH
In the same `~/.profile` file and add these lines to the bottom.  If they are not exact, then your Linux may not be bootable.
```
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```
**logout and login**.  This is the most straightforward way to run/test these changes.


### Install Factom

There are two options, in terms of installing Factom. The first (and probably easiest) option would be to install the binaries, by following the [Factom Binaries Install Guide](http://factom.org/howto).

The second option would be to install from the FactomProject repository on Github. The version intended for testing is in the master branch. These directions install the master branch.
```
go get -v -u github.com/FactomProject/FactomCode/factomd
```
copy the config file
```
mkdir ~/.factom
cp ~/go/src/github.com/FactomProject/FactomCode/factomd/factomd.conf ~/.factom/factomd.conf
```

There are also more detailed instructions on installing and running Factom available [here](https://github.com/FactomProject/FactomDocs/blob/master/communityTesterDirections.md).

### Install Poloniex Price Graph

```
go get -v -u github.com/FactomProject/Testing/examples/go/poloniex
```

### Run Factom

Factom is run as 3 command line programs for this version. First, there is factomd. It connects to the server and handles connections to the internet. 

Open 2 command line windows. In the first one, run `factomd`. It should show lots of technical outputs showing what it is doing. Leave it running.

*Note: if factomd complains about not connecting, make sure your firewall allows connections out to port 8108 (1FAC in hex).*


### Run Poloniex Price Graph

In the second command line window, run the command: `poloniex`

This will retrieve the price data from the corresponding chain in Factom, generate a graph using this data, and launch a browser window where this graph will be visualized in d3.js. 

