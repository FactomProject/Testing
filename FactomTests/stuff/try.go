package main

import "fmt"
import "time"

func main() {
	ts := time.Unix(1441320967,0)
	
	fmt.Println(ts.Format(time.RFC822Z))
}