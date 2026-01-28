package main

import (
	"context"
	"github.com/jackc/pgx/v5"
	"log"
	"net/http"
	"os"
)

func handler(w http.ResponseWriter, r *http.Request) {
	var count int32
	// urlExample := "postgres://username:password@localhost:5432/database_name"
	conn, err := pgx.Connect(context.Background(), os.Getenv("DATABASE_URL"))
	if err != nil {
		log.Printf("Unable to connect to database: %v\n", err)
		return
	}
	defer conn.Close(context.Background())
	_, err = conn.Exec(context.Background(), "create table if not exists pings (status varchar(255), ts timestamp default now())")
	if err != nil {
		log.Println("Failed to create table", err)
		return
	}
	_, err = conn.Exec(context.Background(), "insert into pings (status) values ('ok')")
	if err != nil {
		log.Println("Failed to insert into table", err)
		return
	}
	err = conn.QueryRow(context.Background(), "select count(status) from pings").Scan(&count)
	if err != nil {
		log.Println("Failed", err)
	}
	log.Printf("Number of rows: %d\n", count)
}

func main() {
	http.HandleFunc("/health", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
