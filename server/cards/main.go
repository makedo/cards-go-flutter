package main

import (
	"cards/duren"

	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		//@TODO: CORS
		return true
	},
}

func main() {
	r := mux.NewRouter()

	var durenHandler = duren.NewGameHandler(2)

	go durenHandler.BroadcastState()

	r.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			log.Fatal(err)
		}

		durenHandler.HandleConnection(conn)
	})

	log.Fatal(http.ListenAndServe(":8080", r))
}
