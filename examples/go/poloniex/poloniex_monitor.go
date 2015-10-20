// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package main

import (
	"encoding/hex"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"time"

	"github.com/FactomProject/factom"
	ed "github.com/agl/ed25519"
)

type OrderBook struct {
	Timestamp int64
	FCT_BTC json.RawMessage
	BTC_USD json.RawMessage
}

func (b *OrderBook) String() string {
	p, err := json.Marshal(b)
	if err != nil {
		return err.Error()
	}
	return string(p)
}

func main() {
	book := new(OrderBook)
	
	book.Timestamp = time.Now().Unix()

	// Get Factoid price
	resp1, err := http.Get("http://poloniex.com/public?command=returnOrderBook&currencyPair=BTC_FCT&depth=4")
	if err != nil {
		log.Fatal(err)
	}
	defer resp1.Body.Close()
	fctdata, err := ioutil.ReadAll(resp1.Body)
	if err != nil {
		log.Fatal(err)
	}
	book.FCT_BTC = fctdata

	// Get BTC_USD price
	resp2, err := http.Get("http://poloniex.com/public?command=returnOrderBook&currencyPair=USDT_BTC&depth=4")
	if err != nil {
		log.Fatal(err)
	}
	defer resp2.Body.Close()
	btcdata, err := ioutil.ReadAll(resp2.Body)
	if err != nil {
		log.Fatal(err)
	}
	book.BTC_USD = btcdata

	data, err := json.Marshal(book)
	if err != nil {
		log.Fatal(err)
	}

	secKey := new([64]byte)
	// not the real secret key
	if s, err := hex.DecodeString("0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a"); err != nil {
		log.Fatal(err)
	} else {
		copy(secKey[:], s)
	}
	sig := ed.Sign(secKey, data)

	e := factom.NewEntry()
	// not the real chain
	e.ChainID = "0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b"
	e.ExtIDs = append(e.ExtIDs, hex.EncodeToString(sig[:]))
	e.Content = hex.EncodeToString(data)

	if err := factom.CommitEntry(e, "poloniex"); err != nil {
		log.Fatal(err)
	}
	time.Sleep(10 * time.Second)
	if err := factom.RevealEntry(e); err != nil {
		log.Fatal(err)
	}
}
