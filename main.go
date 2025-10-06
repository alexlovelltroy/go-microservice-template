// SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors
//
// SPDX-License-Identifier: MIT

package main

import (
	"fmt"
	"log"
)

var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
	builtBy = "unknown"
)

func main() {
	fmt.Printf("OpenCHAMI Microservice Template\n")
	fmt.Printf("Version: %s\n", version)
	fmt.Printf("Commit: %s\n", commit)
	fmt.Printf("Built: %s by %s\n", date, builtBy)

	log.Println("Starting application...")

	// TODO: Add your application logic here

	log.Println("Application started successfully")
}
