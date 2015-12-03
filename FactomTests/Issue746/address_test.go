// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package main

import (
	fct "github.com/FactomProject/factoid"
	"testing"
	"fmt"
	"encoding/hex"
)


func Test_Address(test *testing.T) {
	
	b,_:= hex.DecodeString("8cba3aeb7d16269da4f37d0c98979a7d9b23943774be232e817504ec8ab7e2a7")
	adr := fct.NewAddress(b)
	str := fct.ConvertFctAddressToUserStr(adr) 
	fmt.Println(str)
}
	