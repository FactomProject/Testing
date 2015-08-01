// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package test

import (
    "encoding/hex"
    "encoding/binary"
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
    "testing"
)

var _ = time.Second
var _ = state.FactoidState{}
var _ = hex.EncodeToString
var _ = fmt.Printf
var _ = ed25519.Sign
var _ = rand.New
var _ = binary.Write
var _ = fct.Prtln 
var _ = stateinit.GetDatabase
var _ = database.MapDB{}

var fs *Test_state
// sets up teststate.go                                         
func Test_setup_FactoidState (test *testing.T) {
    // Create a Test State
    fs = new(Test_state)
    fs.Init(test)
}


func Test_create_genesis_FactoidState (test *testing.T) {
    fmt.Print("\033[2J")
    
    numBlocks       := 5000
    numTransactions := 500
    maxIn           := 5
    maxOut          := 20
    if testing.Short() {
        fmt.Print("\nDoing Short Tests\n")
        numBlocks       = 5
        numTransactions = 20
        maxIn           = 5
        maxOut          = 5
    }
    
    // Use Bolt DB
    if !testing.Short() {
        fs.SetDB(new(database.MapDB))
        fs.GetDB().Init()
        db := stateinit.GetDatabase("./fct_test.db")
        fs.GetDB().SetPersist(db)
        fs.GetDB().SetBacker(db)
        
        fs.GetDB().DoNotPersist(fct.DB_F_BALANCES)
        fs.GetDB().DoNotPersist(fct.DB_EC_BALANCES)
        fs.GetDB().DoNotPersist(fct.DB_BUILD_TRANS)
        fs.GetDB().DoNotCache(fct.DB_FACTOID_BLOCKS)
        fs.GetDB().DoNotCache(fct.DB_BAD_TRANS)
        fs.GetDB().DoNotCache(fct.DB_TRANSACTIONS)
    }else{
        fs.SetDB(new(database.MapDB))
        fs.GetDB().Init()
    }
    // Set the price for Factoids
    fs.SetFactoshisPerEC(100000)
    err := fs.LoadState()
    if err != nil {
        fct.Prtln("Failed to load:", err)
        test.Fail()
        return
    }
    
    // Make the coinbase very generous
    block.UpdateAmount(100000000000)
    
    var max,min,maxblk int
    min = 100000
    // Create a number of blocks (i)
    for i:=0; i<numBlocks; i++ {
        
        periodMark := 1
        // Create a new block
        for j:=fs.stats.transactions; fs.stats.transactions < j+numTransactions; {      // Execute for some number RECORDED transactions
            
            if periodMark <=10 && fs.stats.transactions%(numTransactions/10)==0 {
                fs.EndOfPeriod(periodMark)
                periodMark++
            }
            
            tx := fs.newTransaction(maxIn,maxOut)
            
            
            addtest := true
            flip := rand.Int()%100
            if rand.Int()%100 < 5 { // Mess up the timestamp on 5 percent of the transactions
                addtest = false
                blkts := uint64(fs.GetCurrentBlock().GetCoinbaseTimestamp())
                if flip < 49 {    // Flip a coin
                    tx.SetMilliTimestamp(blkts - uint64(fct.TRANSACTION_PRIOR_LIMIT)-1)
                    fs.stats.errors["trans too early"] += 1
                    fs.stats.full["trans too early"]="trans too early"
                }else{
                    tx.SetMilliTimestamp(blkts + uint64(fct.TRANSACTION_POST_LIMIT)+1)
                    fs.stats.errors["trans too late"] += 1
                    fs.stats.full["trans too late"]="trans too late"
                }
                fs.twallet.SignInputs(tx)
            }
            
            // Test Marshal/UnMarshal
            m,err := tx.MarshalBinary()
            if err != nil { fmt.Println("\n Failed to Marshal: ",err); test.Fail(); return } 
            if len(m) > max { 
                max = len(m)
                cp.CP.AddUpdate(
                    "max transaction size",                                              // tag
                    "info",                                                              // Category 
                    fmt.Sprintf("Max Transaction Size %d",max),                          // Title
                    fmt.Sprintf("<pre>#inputs = %-3d  #outputs = %-3d  #ecoutputs = %-3d<pre>",
                       len(tx.GetInputs()),len(tx.GetOutputs()),len(tx.GetECOutputs())), // Msg
                    0)                                                                   // Expire 
            }
            if len(m) < min { 
                min = len(m)
                cp.CP.AddUpdate(
                    "min transaction size",                                              // tag
                    "info",                                                              // Category 
                    fmt.Sprintf("Min Transaction Size %d",min),                          // Title
                    fmt.Sprintf("<pre>#inputs = %-3d  #outputs = %-3d  #ecoutputs = %-3d<pre>",
                       len(tx.GetInputs()),len(tx.GetOutputs()),len(tx.GetECOutputs())), // Msg
                    0)                                                                   // Expire 
            }
           
            k := rand.Int()%(len(m)-2)
            k++
            good := true
            flip = rand.Int()%100
            // To simulate bad data, I mess up some of the data here.
            if rand.Int()%100 < 5 { // Mess up 5 percent of the transactions
                good = false
                if flip < 49 {    // Flip a coin
                    m = m[k:]
                    fs.stats.errors["lost start of trans"] += 1
                    fs.stats.full["lost start of trans"]="lost start of trans"
                }else{
                    m = m[:k]
                    fs.stats.errors["lost end of trans"] += 1
                    fs.stats.full["lost end of trans"]="lost end of trans"
                }
            }
            
            t := new(fct.Transaction)
            err = t.UnmarshalBinary(m)
            
            if good && tx.IsEqual(t) != nil { 
                fmt.Println("Fail valid Unmarshal")
                test.Fail()
                return
            }
            if err == nil {
                if good && err != nil  { 
                    fmt.Println("Added a transaction that should have failed to be added")
                    fmt.Println(err)
                    test.Fail();
                    return
                }
                if !good {
                    fmt.Println("Failed to add a transaction that should have added")
                    test.Fail(); 
                    return
                }
            }
                            
            if good {
                err = fs.AddTransaction(j,t)
            }
            if !addtest  && err == nil {
                ts := int64(t.GetMilliTimestamp())
                bts := int64(fs.GetCurrentBlock().GetCoinbaseTimestamp())
                fmt.Println("timestamp failure ", ts, bts, ts-bts, fct.TRANSACTION_POST_LIMIT)
                test.Fail()
                return
            }
            if !addtest && err == nil {
                fmt.Println("failed to catch error")
                test.Fail()
                return
            }
            
            if addtest && good && err != nil {   
                fmt.Println(err)
                fmt.Println("Unmarshal Failed. trans is good",
                            "\nand the error detected: ",err,
                            "\nand k:",k, "and flip:",flip)
                test.Fail() 
                return 
            } 
            
            if good && addtest {
                fs.stats.transactions += 1
                
                title := fmt.Sprintf("Bad Transactions: %d  Total transaactions %d",
                                     fs.stats.badAddresses,fs.stats.transactions)
                cp.CP.AddUpdate("Bad Transaction","status", title, "", 0) 
                
                time.Sleep(time.Second/100)
            }else{
                fs.stats.badAddresses += 1
            }
            
        }
        //
        // Serialization deserialization tests for blocks
        //
        blkdata,err := fs.GetCurrentBlock().MarshalBinary()
        if err != nil { test.Fail(); return }
        blk := fs.GetCurrentBlock().GetNewInstance().(block.IFBlock)
        err = blk.UnmarshalBinary(blkdata)
        if err != nil { test.Fail(); return }
        if len(blkdata)>maxblk {
            maxblk = len(blkdata)
            cp.CP.AddUpdate(
                "maxblocksize",                                   // tag
                "info",                                           // Category 
                fmt.Sprintf("Max Block Size: %dK",maxblk/1024),   // Title
                "",                                               // Msg
                0)                                                // Expires  
        }
        sec1    := fs.stats.TransactionsPerSec()
        sec2    := fs.stats.TotalTransactionsPerSec()
        cp.CP.AddUpdate(
            "transpersec",                                    // tag
            "info",                                           // Category 
            fmt.Sprintf("Transactions per second %4.2f, (+ bad) %4.2f",sec1,sec2), // Title
                        "",                                   // Msg
                        0)                                    // Expires  
        
        fs.ProcessEndOfBlock()             // Process the block.
        
        c := 1
        keys := make([]string, 0, len(fs.stats.errors))
        for k := range fs.stats.errors {
            keys = append(keys, k)
        }
        for i := 0; i<len(keys)-1; i++ {
            for j:=0;j<len(keys)-i-1; j++ {
                if keys[j]<keys[j+1] {
                    t := keys[j]
                    keys[j] = keys[j+1]
                    keys[j+1]=t
                }
            }
        }
        var out bytes.Buffer
        for _,key := range keys {
            ecnt := fs.stats.errors[key]
            by  := []byte(fs.stats.full[key])
            prt := string(by)
            if len(prt)>80 { prt = string(by[:80])+"..." }
            prt = strings.Replace(prt,"\n"," ",-1)
            out.WriteString(fmt.Sprintf("%6d %s\n",ecnt,prt))
            c++
        }
         cp.CP.AddUpdate(
                "transerrors",                                    // tag
                "errors",                                         // Category 
                "Transaction Errors Detected:",                   // Title
                "<pre>"+string(out.Bytes())+"</pre>",             // Msg
                0)                                                // Expires  
        
    }
    fmt.Println("\nDone")
}

func Test_build_blocks_FactoidState (test *testing.T) {
    
    
}


