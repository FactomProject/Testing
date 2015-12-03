# how to git:
# ----------
# from ~/robertubuntu/testing/test-plans-and-scripts/

cd ~/robertubuntu/testing/test-plans-and-scripts/
git add .
git commit -m "script updates"
git push origin master

# how to retrieve from git
#------------------------
git pull

# when compiling gives "FactomCode/anchorutil/anchorutil.go:20:2: cannot find package "github.com/btcsuite/btcd/wire" in any of:
	/usr/local/go/src/github.com/btcsuite/btcd/wire (from $GOROOT)
	/home/factom/go/src/github.com/btcsuite/btcd/wire (from $GOPATH)"

go get -v github.com/btcsuite/btcd/wire


