package main

import (
	"log"

	"github.com/RelationalAI/sales-engineering/common/rest-api-go/database"
	"github.com/RelationalAI/sales-engineering/common/rest-api-go/rest"
)

func main() {
	err := database.Connect()
	if err != nil {
		log.Fatal(err)
	} else {
		log.Println("RAI connected successfuly")

		rest.Run()
	}
}
