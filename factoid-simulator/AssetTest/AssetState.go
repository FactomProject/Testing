// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

// Defines the state for factoid.  By using the proper
// interfaces, the functionality of factoid can be imported
// into any framework.
package state

import (
    "fmt"
    "time"
    "encoding/hex"
    "crypto/sha256"
    "bytes"
    fct "github.com/FactomProject/factoid"
    "github.com/FactomProject/factom"
    "github.com/FactomProject/factoid/state"
    "github.com/FactomProject/factoid/wallet"
    cp "github.com/FactomProject/FactomCode/controlpanel"
    db "github.com/FactomProject/factoid/database"
)

var _ = time.Sleep
var _ = bytes.Compare

type IAssetState interface {
    
    // The Asset Name is used to find the chain in Factom.
    // This same code can be used to manage many different
    // sorts of assets.
    AssetName() ([]string, error)
    ChainID() []byte
    SetAssetName([]string) error
    // Set the database for the Asset State.  This is where
    // we manage the balances for transactions in this asset.  
    SetDB(db.IFDatabase)  
    GetDB() db.IFDatabase
    
    // Load the state of Asset (or catch up the state of the
    // asset.
    LoadState() error 
    
    // Get the wallet used to help manage the Asset State.
    GetWallet() wallet.ISCWallet
    SetWallet(wallet.ISCWallet) 
        
    // Update balance updates the balance for the asset address in
    // the database.  Note that we take an int64 to allow debits
    // as well as credits.  This is an interal function, and 
    // changing the local database in no way can compromise the
    // balances of assets held in Factom.
    UpdateBalance(address fct.IAddress, amount int64)  error
        
    // Return the Asset balance for an address
    GetBalance(address fct.IAddress) uint64
            
    // Time is something that can vary across multiple systems, and
    // must be controlled in order to build reliable, repeatable
    // tests.  Therefore, no node should directly querry system
    // time.  
    GetTimeMilli() uint64    // Count of milliseconds from Jan 1,1970
    GetTime() uint64         // Count of seconds from Jan 1, 1970
    
    // Validate transaction
    // Return zero len string if the balance of an address covers each input
    Validate(fct.ITransaction) error
        
    // Update Transaction just updates the balance sheet with the
    // addition of a transaction.
    UpdateTransaction(fct.ITransaction) error
    
    // Add a Transaction to the current block.  The transaction is
    // validated against the address balances, which must cover The
    // inputs.  Returns true if the transaction is added.
    AddTransaction(fct.ITransaction) error
    
    // Get the block height for this asset.
    GetAssetHeight() uint32
    
}

type AssetState struct {
    IAssetState
    name            []string 
    chainId         []byte
    database        db.IFDatabase
    nextblockheight int                  // This the height of the next block.
    wallet          wallet.ISCWallet
    numTransactions int
}

var _ IAssetState = (*AssetState)(nil)

func(fs *AssetState) GetAssetName() []string {
    if fs.name == nil {
        fs.name = []string {"Asset", "Trees"}
    }
    return fs.name
}

func(fs *AssetState) SetAssetName([]string) error  {
    return fmt.Errorf("Can't change the Asset Name Yet")
    // this requires clearing our state, changing databases, etc, etc.
}

func(fs *AssetState) GetAssetChainID() []byte {
    if fs.chainId == nil {
        fs.chainId, _ = GetChainId(fs.GetAssetName())
    }
    return fs.chainId
}

func(fs *AssetState) GetWallet() wallet.ISCWallet {
    return fs.wallet
}

func(fs *AssetState) SetWallet(w wallet.ISCWallet) {
    fs.wallet = w
}


// Only add valid transactions to the current block.
func(fs *AssetState) AddTransaction(trans fct.ITransaction) error {
    if err := fs.Validate(trans);                     err != nil { return err }
    if err := fs.UpdateTransaction(trans);            err != nil { return err }
  
    return nil
}

// Assumes validation has already been done.
func(fs *AssetState) UpdateTransaction(trans fct.ITransaction) error {
    for _,input := range trans.GetInputs() {
        fs.UpdateBalance(input.GetAddress(), - int64(input.GetAmount()))
    }
    for _,output := range trans.GetOutputs() {
        fs.UpdateBalance(output.GetAddress(), int64(output.GetAmount()))
    }
    
    fs.numTransactions++
    cp.CP.AddUpdate(
        "transprocessed",                                               // tag
        "status",                                                       // Category 
        fmt.Sprintf("Factoid Transactions Processed: %d",fs.numTransactions),   // Title
        "",                                                             // Message
        0)                                                              // When to expire the message; 0 is never  

    return nil
}
 
// This is the Baby of Asset tracking!  We get the current height of our block
// and we go through each entry, unmarshalling it and building a "block".  We
// then process that block.
//
// We process transactions in our chain, and maintain a balance of our assets.
//
func(fs *AssetState) LoadState() error  {

    // First we need to build our list of blocks going back.
    var blklist []factom.EBlock
    
    // Get me a chain head...
    blkmr, err := factom.GetChainHead(hex.EncodeToString(fs.ChainID()))
    if err != nil { return err }
    blk, err := factom.GetEBlock(blkmr.ChainHead)
        
    for {
        if blk.Header.BlockSequenceNumber < fs.nextblockheight {break}  
        blklist = append(blklist,*blk)
        if blk.Header.BlockSequenceNumber == 0 {break}
        nblk, err := factom.GetEBlock(blk.Header.PrevKeyMR)
        if err != nil { 
            fmt.Println("Error Reading Entry blocks") 
            time.Sleep(time.Second)
            continue 
        } 
        blk = nblk
    }
    
    // Now process blocks forward
    
    for i:= len(blklist)-1; i >=0; i-- {
        for _,entry := range blklist[i].EntryList {
            transEntry, err := factom.GetEntry(entry.EntryHash)
            t := new(fct.Transaction)
            transdata, err := hex.DecodeString(transEntry.Content)
            if err != nil { continue }              // Ignore bad entries.
            err = t.UnmarshalBinary(transdata)
            if err != nil { continue }              // Ignore bad entries.
            fs.AddTransaction(t)
        }
    }
        
    return nil
}
    
// Returns an error message about what is wrong with the transaction if it is
// invalid, otherwise you are good to go.
func(fs *AssetState) Validate(trans fct.ITransaction) error  {
    
    if err := trans.ValidateSignatures(); err != nil { return err }
    
    var sums = make(map[fct.IAddress]uint64,10)
    for _, input := range trans.GetInputs() {
        bal,err := fct.ValidateAmounts(
            sums[input.GetAddress()],           // Will be zero the first time around 
            input.GetAmount())                  // Get this amount, check against bounds
        if err != nil { 
            return err
        }
        if bal > fs.GetBalance(input.GetAddress()) {
            return fmt.Errorf("Not enough funds in input addresses for the transaction")
        }
        sums[input.GetAddress()] = bal
    }
    return nil
}


func(fs *AssetState) GetTimeMilli() uint64 {
    return uint64(time.Now().UnixNano())/1000000  // 10^-9 >> 10^-3
}

func(fs *AssetState) GetTime() uint64 {
    return uint64(time.Now().Unix())
}

func(fs *AssetState) SetDB(database db.IFDatabase){
    fs.database = database
}

func(fs *AssetState) GetDB() db.IFDatabase {
    return fs.database 
}

// Any address that is not defined has a zero balance.
func(fs *AssetState) GetBalance(address fct.IAddress) uint64 {
    balance := uint64(0)
    b  := fs.database.GetRaw([]byte(fct.DB_F_BALANCES),address.Bytes())
    if b != nil  {
        balance = b.(*state.FSbalance).Number
    }
    return balance
}

// Update balance throws an error if your update will drive the balance negative.
func(fs *AssetState) UpdateBalance(address fct.IAddress, amount int64) error {
    nbalance := int64(fs.GetBalance(address))+amount
    if nbalance < 0 {return fmt.Errorf("New balance cannot be negative")}
    balance := uint64(nbalance)
    fs.database.PutRaw([]byte(fct.DB_F_BALANCES),address.Bytes(),&state.FSbalance{Number: balance})
    return nil
} 

// Update ec balance throws an error if your update will drive the balance negative.
func(fs *AssetState) UpdateECBalance(address fct.IAddress, amount int64) error {
    nbalance := int64(fs.GetBalance(address))+amount
    if nbalance < 0 {return fmt.Errorf("New balance cannot be negative")}
    balance := uint64(nbalance)
    fs.database.PutRaw([]byte(fct.DB_EC_BALANCES),address.Bytes(),&state.FSbalance{Number: balance})
    return nil
} 

   
// Use Entry Credits.  Note Entry Credit balances are maintained
// as entry credits, not Factoids.  But adding is done in Factoids, using
// done in Entry Credits.  Using lowers the Entry Credit Balance.
func(fs *AssetState) UseECs(address fct.IAddress, amount uint64) error {
    balance := fs.GetBalance(address)-amount
    if balance < 0 { return fmt.Errorf("Overdraft of Entry Credits attempted.") }
    fs.database.PutRaw([]byte(fct.DB_EC_BALANCES),address.Bytes(),&state.FSbalance{Number: balance})
    return nil
}      
    
// Any address that is not defined has a zero balance.
func(fs *AssetState) GetECBalance(address fct.IAddress) uint64 {
    balance := uint64(0)
    b  := fs.database.GetRaw([]byte(fct.DB_EC_BALANCES),address.Bytes())
    if b != nil  {
        balance = b.(*state.FSbalance).Number
    }
    return balance
}
    
/*******************************************************
*          Helper functions
*******************************************************/


// A Chain ID is constructed by taking the hash of each of the name 
// components, then hashing the lot together.  This way, there are
// nothing but theoretical-but-never-seen collisions between a ChainID
// and a single component name.
func GetChainId(parts [] string) ([]byte, error) {
    if len(parts)<2 {
        return nil, fmt.Errorf("No Chain Specification provided")
    }
    sum := sha256.New()

    for i, str := range parts {
        if i > 0 {
            x := sha256.Sum256([]byte(str))
            sum.Write(x[:])
        }
    }
    
    return sum.Sum(nil), nil
}
