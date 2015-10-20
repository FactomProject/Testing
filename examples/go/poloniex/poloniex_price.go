// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package main

import (
	"encoding/hex"
	"encoding/json"
	"fmt"
	"log"

	"github.com/FactomProject/factom"
	ed "github.com/agl/ed25519"
)

var (
	chainid = "4bf71c177e71504032ab84023d8afc16e302de970e6be110dac20adbf9a19746"
)

type OrderBook struct {
	Timestamp int64
	FCT_BTC json.RawMessage
	BTC_USD json.RawMessage
}

func main() {
	es, err := getValidEntries()
	if err != nil {
		log.Fatal(err)
	}
	
	for _, e := range es {
		fmt.Println(string(e.Content))
	}
	fmt.Println(len(es), "Valid Entries")
}

func getValidEntries() ([]*factom.Entry, error) {
	es, err := factom.GetAllChainEntries(chainid)
	if err != nil {
		return nil, err
	}
	
	validEntries := make([]*factom.Entry, 0)
	for _, e := range es {
		if poloniexIsValid(e) {
			validEntries = append(validEntries, e)
		}
	}
	
	return validEntries, nil
}

func poloniexIsValid(e *factom.Entry) bool {
	pub := new([32]byte)
	if p, err := hex.DecodeString("ca81e518e9a5519b7b218b85b13d73447f65c48c9c6f1b67db55a54ab48fc1de"); err == nil {
		copy(pub[:], p)
	}
	
	sig := new([64]byte)
	copy(sig[:], e.ExtIDs[0])
	
	if !ed.Verify(pub, e.Content, sig) {
		return false
	}
	
	b := new(OrderBook)
	if err := json.Unmarshal(e.Content, b); err != nil {
		return false
	} else if b.Timestamp == 0 {
		return false
	}
	
	return true
}
