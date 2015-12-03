// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package main

import (
    "encoding/hex"
    "encoding/binary"
    "os"
    "fmt"
    "bytes"
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
    "encoding/json"
    "net/http"
    "io/ioutil"
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
    ipaddressFD      = "localhost:"
    portNumberFD     = "8088"
)

func GetBalance ( publicKey []byte) error {
    
    return nil
}

// FactoidSubmit assumes the caller has already validated and signed
// the transaction.  No checking is done, it is just submitted to Factom.
func FactoidSubmit(trans fct.ITransaction) (err error) {
        
    var data []byte
    if data, err = trans.MarshalBinary(); err != nil { return err }
    
    transdata := string(hex.EncodeToString(data))
    
    s := struct{ Transaction string }{transdata}
    
    var js [] byte
    if js, err = json.Marshal(s); err != nil { return err }
    
    resp, err := http.Post(
        fmt.Sprintf("http://%s/v1/factoid-submit/", ipaddressFD+portNumberFD),
                           "application/json",
                           bytes.NewBuffer(js))
    
    if err != nil {
        return err
    }
    
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        return err
    }
    
    resp.Body.Close()
    
    type rtnStruct struct { 
        Response string
        Success  bool
    }
    rtn := new(rtnStruct)
    if err := json.Unmarshal(body, rtn); err != nil {
        return err
    }
    
    if !rtn.Success {
        return fmt.Errorf(rtn.Response)
    }
    
    return nil
}

func main(){}