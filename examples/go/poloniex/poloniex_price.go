// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package main

import (
	"encoding/hex"
	"encoding/json"
	"fmt"
	"log"
    "net/http"
 	"html/template"
	"github.com/FactomProject/factom"
	ed "github.com/agl/ed25519"
 	"bytes"
)

var (
	chainid = "4bf71c177e71504032ab84023d8afc16e302de970e6be110dac20adbf9a19746"
)

type OrderBook struct {
	Timestamp int64
	FCT_BTC json.RawMessage
	BTC_USD json.RawMessage
}

type PassJSON struct {
    PoloniexData string
}

func main() {
    //set up handler for generating graph
 	http.HandleFunc("/", renderGraph)
    //start webserver goroutine (non-blocking)                
    go http.ListenAndServe(":8094", nil)
    //open user's browser, to view graph
    Open("http://localhost:8094")
    //sleep forever (until manual termination)
    select{}
}  
    
func renderGraph(w http.ResponseWriter, r *http.Request) {
	es, err := getValidEntries()
	if err != nil {
		log.Fatal(err)
	}
    //used to store/pass JSON data
    var buffer bytes.Buffer
    //begin JSON array
    buffer.WriteString("[")
	for i, e := range es {
        //add Valid Entry to JSON array
        buffer.WriteString(string(e.Content))
		if i < len(es) - 1 {
            //comma-delimit objects in JSON array
		    buffer.WriteString(",")
		}
	}
    //end JSON array
	buffer.WriteString("]")
	
    //parse d3.js template file
    t, err := template.ParseFiles("linechart.html")
    if err != nil {
        fmt.Println("Template parse error: ", err.Error())
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    
    //prepare JSON array to be passed to page
    passData := PassJSON{string(buffer.Bytes())}

    //pass JSON array to be graphed with d3.js
    if err := t.Execute(w, passData); err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
    }
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
