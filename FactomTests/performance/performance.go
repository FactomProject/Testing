// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package main

import (
	"fmt"
	"time"
	"sync"
)

var _ = fmt.Println

func main() {
	
	sem := new(sync.Mutex)
	now := time.Now()
	var i int
	for i=0; i<10000000; i++ {
		sem.Lock()
		sem.Unlock()
	}
	fmt.Println(i, time.Since(now))
}