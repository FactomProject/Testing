// Copyright 2015 Factom Foundation
// Use of this source code is governed by the MIT
// license that can be found in the LICENSE file.

package main

import (
	"fmt"
	"time"
)

var (
	test chan int
	ret  chan int
)

func reflect() {
	for {
		v := <- test
		ret <- v
	}
}

type empty {}
type semaphore chan empty
var sem = make(semaphore, N)
// acquire n resources
func (s semaphore) P(n int) {
	e := empty{}
	for i := 0; i < n; i++ {
		s <- e
	}
}

// release n resources
func (s semaphore) V(n int) { 
	for i := 0; i < n; i++ {
		<-s
	}
}

func reflect2(i int) int {
	fmt.Println("r2")
	sem.P(1)
	v := i
	sem.V(1)
	fmt.Println("v",v)
	return v
}

func main() {
	{
	test = make(chan int)
	ret = make(chan int)
	
	now := time.Now()
	go reflect()
	var sum int
	var i int
	for i=0; i<1000000; i++ {
		test <- i
		v := <- ret
		sum += v
	}
	fmt.Println(i, sum, time.Since(now))
	}
	{
		lock = make(chan int)
		now := time.Now()
		var sum int
		for i:=0; i<1000000; i++ {
			v := reflect2(i)
			sum += v
		}
		fmt.Println(sum, time.Since(now))
	}
}