#!/bin/bash

TMPDIR="/tmp/factomd-p2p-test-build"
mkdir $TMPDIR
cd "$GOPATH/src/github.com/FactomProject/factomd"
echo "Building linux factomd and putting it in $TMPDIR"
CGO_ENABLED=0 GOOS=linux go build go install -ldflags "-X github.com/FactomProject/factomd/engine.Build=`git rev-parse HEAD`" -installsuffix cgo -o "$TMPDIR/factomd"
