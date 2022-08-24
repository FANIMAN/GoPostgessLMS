package main

import (
	"database/sql"
	"log"
	"net/http"
	//"github.com/gorilla/mux"
)

var db *sql.DB

func init() {
	tmpDB, err := sql.Open("postgres", "dbname=books_db user=postgres password=faniman0938 host=localhost sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}
	db = tmpDB
}

func main() {
	http.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir("../web/assets"))))

	http.HandleFunc("/", HandleListBooks)
	http.HandleFunc("/book.html", HandleViewBook)
	http.HandleFunc("/save", HandleSaveBook)
	http.HandleFunc("/delete", HandleDeleteBook)
	log.Fatal(http.ListenAndServe(":3000", nil))
}


