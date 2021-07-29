package main

import (
	"net/http"
	"os"
)

func main() {
	_, err := http.Get("http://localhost:8080/health")
	if err != nil {
		os.Exit(1)
	}
}
