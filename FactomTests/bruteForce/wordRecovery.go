package main

import (
	"bufio"
	"fmt"
	//"github.com/FactomProject/factoid"
	"github.com/FactomProject/factoid/wallet"
	"os"
	"strings"
	"github.com/FactomProject/go-bip39"
	"encoding/hex"
	"bytes"
)

func main() {
	fmt.Print("First find the expected ed25519 key.  for the purchase\nc6bb2bba4e916f8106a17942a2f5b1f4ecc30e7d889de466c7a7ada22cc8f451 it would be\n497db60aa8e18f466cb7cbcfc61620f13d6f4d030f854ad582a3450c31d3930d\n\n")

	fmt.Print("To see how this program is supposed to work, first enter this pubkey e5a19e6235f55719d07520455a5f6a05ffc6c88ea3b08a58ad90a56a25a5c13e then use these words:\nyellow yellow yellow abandon yellow yellow yellow yellow yellow yellow yellow yellow\n\n\n")

	k := bufio.NewScanner(os.Stdin)
	
	fmt.Print("Enter ed25519 pubkey from OP_RETURN here: ")
	k.Scan()
	pubkeyhex := k.Text()
	
	fmt.Printf("You entered %v\n", pubkeyhex)
	
	
	
	r := bufio.NewScanner(os.Stdin)

	fmt.Print("Enter 12 words from Koinify here: ")
	r.Scan()
	line := r.Text()
	args := strings.Fields(string(line))

	if len(args) == 12 {

		mnemonic := ""
		for _, v := range args {
			v = strings.ToLower(v)
			mnemonic = mnemonic + v + " "
		}
		mnemonic = strings.TrimSpace(mnemonic)
		err := checkSpellings(args)
		if (err == nil ) {
			desiredpubkey,_ := hex.DecodeString(pubkeyhex)
			tryAlternateWords(args, desiredpubkey )
		}
		/*
		private, err := wallet.MnemonicStringToPrivateKey(mnemonic)
		if err != nil {
			fmt.Print("\n\nThere was a problem with the 12 words you entered. Please check spelling against this list:\n")
			fmt.Print("https://github.com/FactomProject/go-bip39/blob/master/wordlist.go\n\n\n\n")
			panic(err)
		}
		pub, priv, err := wallet.GenerateKeyFromPrivateKey(private)
		if err != nil {
			panic(err)
		}

		we := new(wallet.WalletEntry)
		we.AddKey(pub, priv)
		we.SetName([]byte("test"))
		we.SetRCD(factoid.NewRCD_1(pub))
		we.SetType("fct")

		address, _ := we.GetAddress()

		adr := factoid.ConvertFctAddressToUserStr(address)

		fmt.Printf("\nFactoid Address: %v\n", adr)
		fmt.Printf("\nCheck your balance at http://explorer.factom.org/\n")
		*/
	} else {
		fmt.Printf("\n\nError: 12 and only 12 words are expected.\n")
	}
	fmt.Printf("\n")
}

func checkSpellings(words []string) (error) {
	var found bool = false
	for _, v := range words{
		for _, w := range bip39.EnglishWordList{
			if w == v{
				//fmt.Printf("%v\n", v)
				found = true
				break
			}
		}
		if false == found{
			fmt.Printf("oops! %v is not a recognized word.  did you mean one of these?\n", v)
			for _, x := range bip39.EnglishWordList{
				if x[:1] == v[:1]{
					fmt.Printf("%v ", x)
				}
			}
			fmt.Printf("\n")
			return fmt.Errorf("Bad Word")
		}
		found = false
	}
	return nil
}

func tryAlternateWords(words []string, desiredpubkey []byte) {
	mnemonic := ""
	tempwordlist := make([]string, 12, 12)
	for i, _ := range words {
		tempwordlist[i] = words[i]
	}
	
	for i, _ := range words {
		fmt.Printf("\n word %v \n", (i+1))
		for _, w := range bip39.EnglishWordList{
			tempwordlist[i] = w
			mnemonic = ""
			for _, v := range tempwordlist {
				v = strings.ToLower(v)
				mnemonic = mnemonic + v + " "
			}
			mnemonic = strings.TrimSpace(mnemonic)
			private, err := mnemonicToKey(mnemonic)
			
			if err == nil {
				pub, _,_  := genPrivateKey(private)
				if bytes.Equal(pub, desiredpubkey) {
					fmt.Printf("\n\ncorrect words are: %v\n\n", mnemonic)
				}
				fmt.Printf("x")
			} else {
				fmt.Printf(".")
			}
		}
		tempwordlist[i] = words[i]

	}
}

func mnemonicToKey(mnemonic string) ([]byte, error) {
	defer func() {
		
		if r := recover(); r != nil {

		}
	}()
	private, err := wallet.MnemonicStringToPrivateKey(mnemonic)
	
	return private, err
}

func genPrivateKey(privateKey []byte) (public []byte, private []byte, err error) {
	defer func() {
		
		if r := recover(); r != nil {

		}
	}()
	public, private, err = wallet.GenerateKeyFromPrivateKey(privateKey)
	return
}
