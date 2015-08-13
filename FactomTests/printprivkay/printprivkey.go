// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package main

import (
    "encoding/hex"
    "encoding/binary"
    "os"
    "fmt"
    "time"
    "strings"
    cp "github.com/FactomProject/FactomCode/controlpanel"
    fct "github.com/FactomProject/factoid"
    "github.com/FactomProject/factoid/state/stateinit"
    "github.com/FactomProject/factoid/state"
    "github.com/FactomProject/factoid/block"
    "github.com/FactomProject/factoid/database"
    "github.com/FactomProject/ed25519"
    "math/rand"
	"github.com/FactomProject/FactomCode/util"        
  )

var (
    _ = (*block.FBlock)(nil)
    _ = cp.CP
    _ = strings.Replace
    _ = os.Exit
    _ = time.Second
    _ = state.FactoidState{}
    _ = hex.EncodeToString
    _ = fmt.Printf
    _ = ed25519.Sign
    _ = rand.New
    _ = binary.Write
    _ = fct.Prtln 
    _ = stateinit.GetDatabase
    _ = database.MapDB{}
)

var (
    cfg = util.ReadConfig().Wallet
    IpAddress        = cfg.Address
    PortNumber       = cfg.Port
    applicationName  = "Factom/fctwallet"
    dataStorePath    = cfg.DataFile
    refreshInSeconds = cfg.RefreshInSeconds
    
    ipaddressFD      = "localhost:"
    portNumberFD     = "8088"
    
    databasefile     = "factoid_wallet_bolt.db"
)

var factoidState = stateinit.NewFactoidState(cfg.BoltDBPath + databasefile)

func main() {
    // Get a wallet
    wallet := factoidState.GetWallet()    
    
    fmt.Printf("wallet:%v\n", wallet)
    
    addr, _ := hex.DecodeString("EC1odMm6FzzpPrsA9mAVUex81FrP9EamNPTRomJWZqyKeLXn43aM")
    
    we := wallet.GetAddressDetailsAddr(addr)
    
    if we == nil {
    	fmt.Println("Wallet entry not found")
    	return
    }
    pub := we.GetKey(0)
    pri := we.GetPrivKey(0)
    fmt.Printf("Public Key:  %x\n", pub)
    fmt.Printf("Private Key: %x\n", pri)
    
}