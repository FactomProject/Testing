// Copyright 2015 FactomProject Authors. All rights reserved.
// Use of this source code is governed by the MIT license
// that can be found in the LICENSE file.

// factomlog is based on github.com/alexcesaro/log and
// github.com/alexcesaro/log/golog (MIT License)

package main

import (
	"encoding/hex"
//	"encoding/json"
	"fmt"
	"os"
	"bufio"
	"strings"
	"time"

//	"github.com/FactomProject/FactomCode/anchor"
	"github.com/FactomProject/FactomCode/common"
	"github.com/FactomProject/factom"
	"github.com/davecgh/go-spew/spew"
)

var (
    inputfile     = "/home/jlu/server/binary.txt"
    ecname = "jackec"
)

func main() {

	inFile, _ := os.Open(inputfile)
  	defer inFile.Close()
  	scanner := bufio.NewScanner(inFile)
  	scanner.Split(bufio.ScanLines)    
  	counter := 0   
  	for scanner.Scan() {
  		line := scanner.Text()
  		index := strings.Index(line, "entry: ")
  		index = index + 7
  		bytes, err := hex.DecodeString(line[index:])
  		if err == nil {
  			entry := common.NewEntry()
  			entry.UnmarshalBinary(bytes)
  			
  			factomEntry := factom.NewEntry()
  			factomEntry.ChainID = entry.ChainID.String()
  			factomEntry.Content = hex.EncodeToString(entry.Content)
  			factom.CommitEntry(factomEntry, ecname)
			time.Sleep(3 * time.Second)
  			factom.RevealEntry(factomEntry)
  			
  			fmt.Println("Successfully submitted:", spew.Sdump(entry))
  		}    	
    	
    	counter ++
  	}
  	
    fmt.Println("Total number of lines:", counter) 
}
