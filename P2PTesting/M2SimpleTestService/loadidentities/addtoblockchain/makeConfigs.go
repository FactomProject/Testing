package main

import (
	"fmt"
	"log"
	"os"
)

func MakeConfigFile(auth hardCodedAuthority, count int) {
	countStr := fmt.Sprintf("%d", count)
	file, err := os.OpenFile("configs/"+countStr+".conf", os.O_RDWR|os.O_CREATE, 0666)
	if err != nil {
		log.Fatal(err)
	}

	str := getString(auth)
	file.WriteString(str)
	file.Close()
}

func getString(auth hardCodedAuthority) string {
	sec, pub := getKeysFromAuth(auth)
	str := `; ------------------------------------------------------------------------------
; App settings
; ------------------------------------------------------------------------------
[app]
PortNumber                            = 8088
HomeDir                               = "/home/factom/"
; --------------- DBType: LDB | Bolt | Map
DBType                                = "LDB"
LdbPath                               = "database/ldb"
BoltDBPath                            = "database/bolt"
DataStorePath                         = "data/export"
DirectoryBlockInSeconds               = 600
ExportData                            = false
ExportDataSubpath                     = "database/export/"
; --------------- Network: MAIN | TEST | LOCAL
Network                               = LOCAL
MainNetworkPort      = 8108
MainPeersFile        = "MainPeers.json"
MainSeedURL          = "https://raw.githubusercontent.com/FactomProject/factomproject.github.io/master/seed/mainseed.txt"
MainSpecialPeers     = ""
TestNetworkPort      = 8109
TestPeersFile        = "TestPeers.json"
TestSeedURL          = "https://raw.githubusercontent.com/FactomProject/factomproject.github.io/master/seed/testseed.txt"
TestSpecialPeers     = ""
LocalNetworkPort     = 8110
LocalPeersFile       = "LocalPeers.json"
LocalSeedURL         = "https://raw.githubusercontent.com/FactomProject/factomproject.github.io/master/seed/localseed.txt"
LocalSpecialPeers     = ""
; --------------- NodeMode: FULL | SERVER | LIGHT ----------------
NodeMode                              = SERVER
IdentityChainID                       = ` + auth.ChainID.String() + `
LocalServerPrivKey                    = ` + sec + `
LocalServerPublicKey                  = ` + pub + `
ExchangeRate                          = 00100000
ExchangeRateChainId		              = eac57815972c504ec5ae3f9e5c1fe12321a3c8c78def62528fb74cf7af5e7389
ExchangeRateAuthorityAddress          = EC2DKSYyRcNWf7RS963VFYgMExoHRYLHVeCfQ9PGPmNzwrcmgm2r

[anchor]
ServerECPrivKey                       = 397c49e182caa97737c6b394591c614156fbe7998d7bf5d76273961e9fa1edd4
ServerECPublicKey                     = 06ed9e69bfdf85db8aa69820f348d096985bc0b11cc9fc9dcee3b8c68b41dfd5
AnchorChainID                         = df3ade9eec4b08d5379cc64270c30ea7315d8a8a1a69efe2b98a60ecdd69e604
ConfirmationsNeeded                   = 20

[btc]
WalletPassphrase                      = "lindasilva"
CertHomePath                          = "btcwallet"
RpcClientHost                         = "localhost:18332"
RpcClientEndpoint                     = "ws"
RpcClientUser                         = "testuser"
RpcClientPass                         = "notarychain"
BtcTransFee                           = 0.000001
CertHomePathBtcd                      = "btcd"
RpcBtcdHost                           = "localhost:18334"

[wsapi]
ApplicationName                       = "Factom/wsapi"
PortNumber                            = 8088

; ------------------------------------------------------------------------------
; logLevel - allowed values are: debug, info, notice, warning, error, critical, alert, emergency and none
; ConsoleLogLevel - allowed values are: debug, standard
; ------------------------------------------------------------------------------
[log]
logLevel                              = error
LogPath                               = "database/Log"
ConsoleLogLevel                       = standard

; ------------------------------------------------------------------------------
; Configurations for fctwallet
; ------------------------------------------------------------------------------
[Wallet]
Address                               = localhost
Port                                  = 8089
DataFile                              = fctwallet.dat
RefreshInSeconds                      = 6
BoltDBPath                            = ""
`

	return str
}