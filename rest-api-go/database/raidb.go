package database

import (
	rai "github.com/relationalai/rai-sdk-go/rai"
)

var raiClient *rai.Client
var profile string = "default"
var database string = "blog-space-stackexchange2"
var engine string = "andre-s"

func Connect() error {
	var err error
	raiClient, err = rai.NewClientFromConfig(profile)
	if err != nil {
		return err
	}
	return nil
}

func ListDataBases() ([]rai.Database, error) {
	return raiClient.ListDatabases()
}

func Execute(relQuery string) (*rai.TransactionResult, error) {
	return raiClient.ExecuteV1(database, engine, relQuery, nil, true)
}
