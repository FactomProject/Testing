//To use, run "btcd --addrindex --testnet" or "btcd --addrindex" for mainnet
//the indexes take a long time to build

//This can be run on any computer that has an indexed blockchain.  A wallet is not needed.

//Set the variables pubkeyhash and pubkey to those found in the block explorer
//for example on this page https://www.blocktrail.com/tBTC/address/mrM9rnFUTZfsxgw6awLr2kRYnLmGHTQ5H2
//the value "Hash 160" is the pubkeyhash
//on this page: https://www.blocktrail.com/tBTC/tx/2d44e2f7b06df27fed539a1b741e1d90cf3ca9dae45cedf81ef90a22ba406d3a
//the 3rd line 02cd3f2f1ab9e89518036e1597e5b59777fbb16df553f6437e5ab40429f497b489 under input scripts is the pubkey

//set the values of factomd.conf RpcBtcdHost to 8334 for mainnet or 18334 for testnet
//also set RpcClientUser and RpcClientPass to be correct

package main

import "fmt"
import "encoding/hex"

import "reflect"
import "sort"
import "strconv"

import (
	"github.com/FactomProject/FactomCode/util"
	"github.com/btcsuitereleases/btcd/btcjson"
	"github.com/btcsuitereleases/btcd/chaincfg"
	"github.com/btcsuitereleases/btcd/wire"
	"github.com/btcsuitereleases/btcrpcclient"
	"github.com/btcsuitereleases/btcutil"
	"io/ioutil"
	"path/filepath"
)

var (
	//balances            []balance // unspent balance & address & its WIF
	cfg              *util.FactomdConfig
	dclient, wclient *btcrpcclient.Client
	//fee                 btcutil.Amount                  // tx fee for written into btc
	//dirBlockInfoMap     map[string]*common.DirBlockInfo //dbHash string as key
	//db                  database.Db
	//walletLocked        bool
	//reAnchorAfter       = 10 // hours. For anchors that do not get bitcoin callback info for over 10 hours, then re-anchor them.
	//reAnchorCheckEvery  = 1  // hour. do re-anchor check every 1 hour.
	//defaultAddress      btcutil.Address
	//confirmationsNeeded int

	//Server Private key for milestone 1
	//serverPrivKey common.PrivateKey

	//Server Entry Credit private key
	//serverECKey common.PrivateKey
	//Anchor chain ID
	//anchorChainID *common.Hash
	//InmsgQ for submitting the entry to server
	//inMsgQ chan factomwire.FtmInternalMsg
)

type Message struct {
	Name string
	Body string
	Time int64
}

func main() {
	fmt.Printf("anchorwatch\n")

	InitRPCClient()
	getheights()
}

// InitRPCClient is used to create rpc client for btcd and btcwallet
// and it can be used to test connecting to btcd / btcwallet servers
// running in different machine.
func InitRPCClient() error {
	//anchorLog.Debug("init RPC client")
	cfg = util.ReadConfig()
	//certHomePath := cfg.Btc.CertHomePath
	//rpcClientHost := cfg.Btc.RpcClientHost
	rpcClientEndpoint := cfg.Btc.RpcClientEndpoint
	rpcClientUser := cfg.Btc.RpcClientUser
	rpcClientPass := cfg.Btc.RpcClientPass
	certHomePathBtcd := cfg.Btc.CertHomePathBtcd
	rpcBtcdHost := cfg.Btc.RpcBtcdHost
	//confirmationsNeeded = cfg.Anchor.ConfirmationsNeeded

	var err error

	// Connect to local btcd RPC server using websockets.
	dntfnHandlers := createBtcdNotificationHandlers()
	certHomeDir := btcutil.AppDataDir(certHomePathBtcd, false)
	fmt.Println("btcd.cert.home=", certHomeDir)
	certs, err := ioutil.ReadFile(filepath.Join(certHomeDir, "rpc.cert"))
	if err != nil {
		return fmt.Errorf("cannot read rpc.cert file for btcd rpc server: %s\n", err)
	}
	dconnCfg := &btcrpcclient.ConnConfig{
		Host:         rpcBtcdHost,
		Endpoint:     rpcClientEndpoint,
		User:         rpcClientUser,
		Pass:         rpcClientPass,
		Certificates: certs,
	}
	dclient, err = btcrpcclient.New(dconnCfg, &dntfnHandlers)
	if err != nil {
		return fmt.Errorf("cannot create rpc client for btcd: %s\n", err)
	}
	fmt.Println("successfully created rpc client for btcd")

	return nil
}

func createBtcdNotificationHandlers() btcrpcclient.NotificationHandlers {

	ntfnHandlers := btcrpcclient.NotificationHandlers{

		OnBlockConnected: func(hash *wire.ShaHash, height int32) {
			//anchorLog.Info("dclient: OnBlockConnected: hash=", hash, ", height=", height)
			//go newBlock(hash, height)	// no need
		},

		OnRecvTx: func(transaction *btcutil.Tx, details *btcjson.BlockDetails) {
			//anchorLog.Info("dclient: OnRecvTx: details=%#v\n", details)
			//anchorLog.Info("dclient: OnRecvTx: tx=%#v,  tx.Sha=%#v, tx.index=%d\n",
			//transaction, transaction.Sha().String(), transaction.Index())
		},

		OnRedeemingTx: func(transaction *btcutil.Tx, details *btcjson.BlockDetails) {
			//anchorLog.Info("dclient: OnRedeemingTx: details=%#v\n", details)
			//anchorLog.Info("dclient: OnRedeemingTx: tx.Sha=%#v,  tx.index=%d\n",
			//transaction.Sha().String(), transaction.Index())

			if details != nil {
				// do not block OnRedeemingTx callback
				//anchorLog.Info("Anchor: saveDirBlockInfo.")
				//go saveDirBlockInfo(transaction, details)
			}
		},
	}

	return ntfnHandlers
}

func getheights() {

	chainParams := &chaincfg.MainNetParams

	//mainnet
	pubkeyhash := "C5B7FD920DCE5F61934E792C7E6FCC829AFF533D"
	pubkey := "027e706cd1c919431b693a0247e4a239e632659a8723a621a91ec610c64f4173ac"

	//testnet
	//pubkeyhash := "76CEE09AAAF961DEFF220E74A032C398CAE5526C"
	//pubkey := "02cd3f2f1ab9e89518036e1597e5b59777fbb16df553f6437e5ab40429f497b489"

	//bo's anchor
	//pubkeyhash := "A5D9CB447A34CAEC3988FD1969EBCED6490FF6E3"
	//pubkey := "03f7b9ff6483234f70dbead7ed29bffee34880440b1be13b660bd7d917c3cc6ccc"

	pubkeyhashb, _ := hex.DecodeString(pubkeyhash)
	addressToSearch, err := btcutil.NewAddressPubKeyHash(pubkeyhashb, chainParams)
	fmt.Printf("err %v\n", err)
	fmt.Printf("address %v\n", addressToSearch)
	skipCount := 0
	resultsWanted := 100000

	searchResults, err := dclient.SearchRawTransactionsVerbose(addressToSearch, skipCount, resultsWanted)

	anchors := make([]string, 0)

	//fmt.Printf("%v\n", search)
	if err != nil {
		//return nil, fmt.Errorf("failed in rpcclient.SendRawTransaction: %s", err)
	}
	numTrans := 0
	for numTransLoop, transaction := range searchResults {
		//j := btcrpcclient.Receive(transaction)

		//fmt.Printf("%v\n", transaction.Txid)
		//fmt.Printf("%v\n", transaction.Vin[0].ScriptSig.Asm)
		ls := len(transaction.Vin[0].ScriptSig.Asm)
		lp := len(pubkey)
		if ls > lp {
			//fmt.Printf("%v\n", transaction.Vin[0].ScriptSig.Asm)
			if reflect.DeepEqual(transaction.Vin[0].ScriptSig.Asm[ls-lp:], pubkey) { //if it comes from the anchor address
				for _, output := range transaction.Vout { //iterate over all the outputs
					//fmt.Printf("%v\n", output.ScriptPubKey.Type)
					if output.ScriptPubKey.Type == "nulldata" { //if the output is an op_return
						//fmt.Printf("%v\n", output.ScriptPubKey.Hex)
						//Combine the value of the opreturn with the bitcoin txid of the anchor transaction
						anchordata := output.ScriptPubKey.Hex[8:]
						anchordata = anchordata + transaction.Txid
						//fmt.Printf("%v\n", anchordata)
						anchors = append(anchors, anchordata)
						//fmt.Printf("%v\n", anchors)
					}
				}
			}
		}

		numTrans = numTransLoop + 1
	}
	fmt.Printf("tx count: %v\n", numTrans)
	duplicates := arrangeAnchors(anchors)
	printDups(duplicates)
	//fmt.Printf("duplicates: %v\n", duplicates)
}

//turn this list of all anchor transactions found into a map
func arrangeAnchors(anchors []string) map[int][]string {
	sort.Strings(anchors)
	var duplists map[int][]string

	duplists = make(map[int][]string)

	for _, anc := range anchors {
		//fmt.Printf(" %v\n", anc)
		//fmt.Println(reflect.TypeOf(anchors))
		height := anc[:12]
		decheight, _ := strconv.ParseInt(height, 16, 32)
		//fmt.Println(reflect.TypeOf(decheight))
		anclist := duplists[int(decheight)]
		anclist = append(anclist, anc)
		duplists[int(decheight)] = anclist
	}

	return duplists
}

//iterate the map and find irregularities (extra and missing anchors)
func printDups(duplist map[int][]string) {

	//fmt.Printf("duplicates: %v\n", duplist)
	numOfHeights := len(duplist)
	fmt.Printf("numOfHeights: %v\n", numOfHeights)
	keys := make([]int, 0)
	for k := range duplist {

		keys = append(keys, int(k))

	}
	sort.Ints(keys)
	//fmt.Printf("keylist: %v\n", keys)

	last := -1
	for _, j := range keys {
		if j != (last + 1) {
			if (last + 1) == (j - 1) {
				fmt.Printf("missing anchors at %v\n", (j - 1))
			} else {
				fmt.Printf("missing anchors between %v and %v\n", (last + 1), (j - 1))
			}
		}
		last = j
		//fmt.Printf("%v ", j)
	}

	for _, j := range keys {
		//fmt.Printf("[%v %v] ", j, len(duplist[j]))
		//fmt.Printf(" %v\n", duplist[j])
		if len(duplist[j]) > 1 {
			fmt.Printf("duplicate at, %v,\n", j)
			for _, d := range duplist[j] {
				fmt.Printf("%v,%v, %v \n", d[:12], d[12:(12+64)], d[(12+64):])
				_ = d
			}
		}
	}
}
