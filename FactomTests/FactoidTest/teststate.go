// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package test

import (
    "fmt"
    "time"
    "bytes"
    "testing"
    "strings"
    "math/rand"
    cv  "strconv"
    fct "github.com/FactomProject/factoid"    
    cp  "github.com/FactomProject/FactomCode/controlpanel"    
    "github.com/FactomProject/factoid/state"    
    "github.com/FactomProject/factoid/wallet"    
)

var _ = fmt.Printf
var _ = strings.Replace

type Stats struct {
    badAddresses int
    transactions int
    errors map[string]int
    full map[string]string
    start time.Time
    blocktimes []time.Time
    AvgBal uint64
    MaxBal uint64
}
func (s *Stats) begin() {
    s.start = time.Now()
}
func (s *Stats) endBlock() {
    s.blocktimes = append(s.blocktimes, time.Now())
}
func (s *Stats) logError(err string) {
    if s.errors == nil {
        s.errors = make(map[string]int)
    }
    cnt := s.errors[err]
    s.errors[err] = cnt+1
}

func (s *Stats) TransactionsPerSec() float64 {
    return float64(s.transactions)/time.Since(s.start).Seconds()
}

func (s *Stats) TotalTransactionsPerSec() float64 {
    return float64(s.transactions+s.badAddresses)/time.Since(s.start).Seconds()
}


type Test_state struct {
    state.FactoidState
    clock int64
    twallet wallet.ISCWallet
    inputAddresses []fct.IAddress        // Genesis Address funds 10 addresses
    outputAddresses []fct.IAddress       // We consider our inputs and ten more addresses
    ecoutputAddresses []fct.IAddress     // Entry Credit Addresses
    stats Stats
}

func(fs *Test_state) Init(test *testing.T) {
    fs.stats.errors = make(map[string]int,100)
    fs.stats.full = make(map[string]string,100)
    
    fs.inputAddresses = make([]fct.IAddress,0,10)
    fs.outputAddresses = make([]fct.IAddress,0,10)
    fs.ecoutputAddresses = make([]fct.IAddress,0,10)
    fs.twallet = new(wallet.SCWallet)              // Wallet for our tests
    fs.twallet.Init()
    
    for i:=0; i<10; i++ {
        addr, err := fs.twallet.GenerateFctAddress([]byte("testin_"+cv.Itoa(i)),1,1)
        if err != nil { fct.Prtln(err); test.Fail() }
        fs.inputAddresses = append(fs.inputAddresses,addr)
        fs.outputAddresses = append(fs.outputAddresses,addr)
    }
    t := fct.NewHash([]byte(fmt.Sprintf("Test State and Balances %v",time.Now().UnixNano()))).String()
    fs.twallet.NewSeed([]byte("Test State and Balances"+t))
    
    for i:=0; i<10000; i++ {
        addr, err := fs.twallet.GenerateFctAddress([]byte("testout_"+cv.Itoa(i)),1,1)
        if err != nil { fct.Prtln(err); test.Fail() }
        fs.outputAddresses = append(fs.outputAddresses,addr)
    }
    for i:=0; i<1000; i++ {
        addr, err := fs.twallet.GenerateECAddress([]byte("testecout_"+cv.Itoa(i)))
        if err != nil { fct.Prtln(err); test.Fail() }
        fs.ecoutputAddresses = append(fs.ecoutputAddresses,addr)
    }
    fs.stats.begin()
}

func(fs *Test_state) GetWallet() wallet.ISCWallet {
    return fs.twallet
}

func(fs *Test_state) GetTime64() int64 {
    return time.Now().UnixNano()
}

func(fs *Test_state) GetTime32() int64 {
    return time.Now().Unix()
}

// Returns a number for the number of inputs, outputs
// or ecoutputs for a transaction.  We spread the odds
// over the magnitude of possible values.
func(fs *Test_state) getRnd() (num int) {

    sw := rand.Int() % 100  // Odds are expressed in percentages
    
    switch {
        case sw < 80:               // 80%
            num = 0x1               // 1 num range
        case sw < 90:               // 10%
            num = rand.Int()%3 + 2  // 2 to 4 num range
        case sw < 95:               // 5%
            num = rand.Int()%6 + 5  // 5 to 10 num range
        case sw < 96:               // 1%
            num = 0                 // 0 
        case sw < 97:               // 1%
            num = rand.Int()%11+11  // 11 to 20 num range
        case sw < 98:
            num = rand.Int()%11+21  // 21 to 30 num range
        case sw < 99:
            num = rand.Int()%11+31  // 31 to 40 num range
        case sw <100:
            num = rand.Int()%215+41 // 41 to 255 num range
    }
    
    return num
}

func(fs *Test_state) newTransaction() fct.ITransaction {
    var maxBal,sum uint64
    fs.inputAddresses = make([]fct.IAddress,0,20)
    
    for _,output := range fs.outputAddresses {
        bal := fs.GetBalance(output)
        if bal > 100000000 {
            fs.inputAddresses = append(fs.inputAddresses, output)
            sum += bal
        }
        if maxBal < bal {
            maxBal = bal
        }
    }
    
    avgBal := sum/uint64(len(fs.inputAddresses))
    
    if fs.stats.transactions == 0 {
        fs.stats.MaxBal = maxBal
        fs.stats.AvgBal = avgBal
    }else{
        fs.stats.MaxBal = (fs.stats.MaxBal*uint64(fs.stats.transactions)+maxBal)/uint64(fs.stats.transactions+1)
        fs.stats.AvgBal = (fs.stats.AvgBal*uint64(fs.stats.transactions)+avgBal)/uint64(fs.stats.transactions+1)
    }
    
    cp.CP.AddUpdate(
        "Test max min inputs",                                               // tag
        "info",                                                              // Category 
        "Tests generation",                                                  // Title
          fmt.Sprintf("Input Addresses %d\n"+
                      "Total Max balance %15s, Average Balance %15s\n"+
                      "Last  Max balance %15s, Average Balance %16s",
             len(fs.inputAddresses),
             strings.TrimSpace(fct.ConvertDecimal(fs.stats.MaxBal)),
             strings.TrimSpace(fct.ConvertDecimal(fs.stats.AvgBal)),
             strings.TrimSpace(fct.ConvertDecimal(maxBal)),
             strings.TrimSpace(fct.ConvertDecimal(avgBal))),                  // Msg
        0)                                                                   // Expire 
    
    // The following code is a function that creates an array
    // of addresses pulled from some source array of addresses
    // selected randomly.
    var makeList = func(source []fct.IAddress, cnt int) []fct.IAddress{
        adrs := make([]fct.IAddress,0,cnt)
        for len(adrs)<cnt {
            var i int
            if len(source) == 0 { return adrs }
            i = rand.Int()%len(source)
            adr := source[i]
            adrs = append(adrs,adr)
        }
        return adrs
    }
        
    // Get one to five inputs, and one to five outputs
    numInputs := fs.getRnd()
    numOutputs := fs.getRnd()
    mumECOutputs := fs.getRnd()
 
    if avgBal > 10000000000 { 
        numOutputs = 0 
    } // Throw away Factoids if too much money in the system
    
    lim := len(fs.inputAddresses)-2
    if lim <= 0 {lim = 1}
    numInputs = (numInputs%(lim))+1

   // fmt.Println("inputs outputs",numInputs,numOutputs, "limits",len(fs.inputAddresses),len(fs.outputAddresses))
    
    // Get my input and output addresses
    inputs := makeList(fs.inputAddresses,numInputs)
    outputs := makeList(fs.outputAddresses,numOutputs)
    ecoutputs := makeList(fs.ecoutputAddresses,mumECOutputs)
    var paid uint64
    t := fs.twallet.CreateTransaction(fs.GetTimeMilli())
    for _, adr := range inputs {
        balance := fs.GetBalance(adr)
        toPay := uint64(rand.Int63())%(balance/2)
        paid = toPay+paid
        fs.twallet.AddInput(t,adr, toPay)
    }
        
    paid = paid - fs.GetFactoshisPerEC()*uint64(len(ecoutputs))
    
    for _, adr := range outputs {
        fs.twallet.AddOutput(t,adr,paid/uint64(len(outputs)))
    }
    
    for _, adr := range ecoutputs {
        fs.twallet.AddECOutput(t,adr,fs.GetFactoshisPerEC())
    }
    
    fee,_ := t.CalculateFee(fs.GetFactoshisPerEC())
    toPay := t.GetInputs()[0].GetAmount()
    fs.twallet.UpdateInput(t,0,inputs[0], toPay+fee)
        
    valid, err1 := fs.twallet.SignInputs(t)
    if err1 != nil {
        fct.Prtln("Failed to sign transaction")
    }
    if !valid {
        fct.Prtln("Transaction is not valid")
    }
    if err := fs.Validate(len(fs.GetCurrentBlock().GetTransactions()), t); 
       err != nil || err1 != nil {
        
        fs.GetDB().Put(fct.DB_BAD_TRANS, t.GetHash(), t)
        
        fs.stats.badAddresses += 1
        
        str := []byte(err.Error())[:10]
        if bytes.Compare(str,[]byte("The inputs"))!=0 {
            str = []byte(err.Error())[:30]
        }
        fs.stats.errors[string(str)] += 1
        fs.stats.full[string(str)] = err.Error()
        
        return fs.newTransaction() 
    }
    return t
}