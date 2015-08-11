// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package main

import (
    "encoding/hex"
    "encoding/binary"
    "os"
    "fmt"
    "strconv"
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
    _ = bytes.Equal
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



func FctBalance(adrtype string, pubKey []byte) (int64, error) {
    
    adr := hex.EncodeToString(pubKey) 
    var str string
    if adrtype == "fct" {
        str = fmt.Sprintf("http://%s/v1/factoid-balance/%s", ipaddressFD+portNumberFD, adr)
    } else {
        str = fmt.Sprintf("http://%s/v1/entry-credit-balance/%s", ipaddressFD+portNumberFD, adr)
    }
    
    resp, err := http.Get(str)
    if err != nil {
        return 0, err
    }

    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        return 0, err
    }
    resp.Body.Close()
    
    type x struct { 
        Response string
        Success  bool
    }
    b := new(x)
    if err := json.Unmarshal(body, b); err != nil {
        return 0, err
    }
    
    if !b.Success {
        return 0, fmt.Errorf("%s",b.Response)
    }
    
    v, err := strconv.ParseInt(b.Response,10,64)
    if err != nil {
        return 0,err
    }
    
    return v, nil
    
}

