package main

import (
	"fmt"
	"log"
	"os"
	"strconv"
)

// Configuration Option
var (
	Host           string = "localhost:8088"
	Amount         int    = 0
	FactoshisPerEC uint64 = 10000
	printMessages  bool   = true
	makeConfigs    bool   = false
	onlyConfigs    bool   = false
)

var _ = fmt.Sprintf("format")

func main() {
	args := os.Args
	var err error

	switch {
	case len(args) > 1: // Host Address
		Host = args[1]
		if Host == "true" {
			makeConfigs = true
			onlyConfigs = true
			setUpAuthorites()
			authorityToBlockchain(100)
			return
		}
		fallthrough
	case len(args) > 2: // Amount of Identites
		Amount, err = strconv.Atoi(args[2])
		if err != nil {
			log.Fatal(err)
		}
		fallthrough
	case len(args) > 3: // Factoshis
		FactoshisPerEC, err = strconv.ParseUint(args[3], 10, 64)
		if err != nil {
			log.Fatal(err)
		}
		fallthrough
	case len(args) > 4:
		if args[4] == "true" {
			makeConfigs = true
		}
	}

	err = fundWallet(2e8)
	if err != nil {
		log.Println(err)
	}
	setUpAuthorites()
	auths, skipped, err := authorityToBlockchain(Amount)
	if err != nil {
		log.Fatal(err)
	}
	if printMessages {
		os.Stderr.WriteString(fmt.Sprintf("=== %d Identities added to blockchain, %d Already there ===\n", len(auths), skipped))
		for _, ele := range auths {
			fmt.Println(ele.ChainID.String())
		}
	}
}
