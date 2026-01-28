package main

import (
	"context"
	"github.com/jackc/pgx/v5"
	"log"
	"net/http"
	"os"
)

func handler(w http.ResponseWriter, r *http.Request) {
	var name string
	// urlExample := "postgres://username:password@localhost:5432/database_name"
	conn, err := pgx.Connect(context.Background(), os.Getenv("DATABASE_URL"))
	if err != nil {
		log.Printf("Unable to connect to database: %v\n", err)
		return;
	}
	defer conn.Close(context.Background())
	err = conn.QueryRow(context.Background(), "SELECT table_name FROM information_schema.tables ORDER BY table_schema,table_name").Scan(&name)
	if err != nil {
		log.Println("Failed", err)
		return;
	}
	log.Println("OK")
}

func main() {
	http.HandleFunc("/health", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
