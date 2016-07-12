package main

import (
	"flag"
	"fmt"
	"github.com/FactomProject/factom"
	"strconv"
	"time"
)

//before running, make sure that factomd and factom-walletd is running and has the zeros ec key in the wallet and that it has a balance

func main() {

	var (
		sflag = flag.String("s", "localhost:8088", "address of api server")
		wflag = flag.String("w", "localhost:8089", "address of wallet api server")
	)
	flag.Parse()
	//args := flag.Args()

	factom.SetFactomdServer(*sflag)
	factom.SetWalletServer(*wflag)

	fmt.Println("Using factomd at", *sflag)
	fmt.Println("Using factom-walletd at", *wflag)

	e := new(factom.Entry)

	ecAddr, _ := factom.GetECAddress("Es2Rf7iM6PdsqfYCo3D1tnAR65SkLENyWJG1deUzpRMQmbh9F3eG")
	bal, err := factom.GetECBalance(ecAddr.String())
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println("address", ecAddr, "has a balance of", bal)

	e.ExtIDs = append(e.ExtIDs, []byte("id"))
	e.Content = []byte("payload")

	c := factom.NewChain(e)

	txID, err := factom.CommitChain(c, ecAddr)
	if err != nil {
		fmt.Println(err)
		return
	}

	fmt.Println("commiting txid:", txID)

	hash, err := factom.RevealChain(c)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("revealed entry:", hash)

	i := 0
	for {
		e.Content = []byte(strconv.Itoa(i))

		//c.ChainID

		txID, err := factom.CommitEntry(e, ecAddr)
		if err != nil {
			fmt.Println(err)
			return
		}

		fmt.Println("commiting txid:", txID)

		hash, err := factom.RevealEntry(e)
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Println("revealed entry:", hash)
		time.Sleep(2 * time.Millisecond)
		i++
	}

}
