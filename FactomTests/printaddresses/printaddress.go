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
    "github.com/FactomProject/factoid/wallet"
    "github.com/FactomProject/factoid/database"
    "github.com/FactomProject/ed25519"
    "math/rand"
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

func main() {
    // Get a wallet
    wallet := new(wallet.SCWallet)          // make me a wallet
    wallet.Init()
    // Generate a Random Seed
    seed := fct.Sha([]byte(fmt.Sprintf("asdfjkoergipupdiofbd;;aerled: %v",time.Now().UnixNano()))).Bytes()
    // Randomize the address generation.  This should be very random, and destroyed for security
    wallet.NewSeed(seed)
    
    addr, err := wallet.GenerateECAddress([]byte("EC Address"))
    if err != nil {
        fmt.Println(err)
        return
    }
    
    we := wallet.GetAddressDetailsAddr(addr.Bytes())
    pub := we.GetKey(0)
    pri := we.GetPrivKey(0)
    fmt.Printf("Public Key:  %x\n", pub)
    fmt.Printf("Private Key: %x\n             %x\n", pri[:32],pri[32:])
    
}