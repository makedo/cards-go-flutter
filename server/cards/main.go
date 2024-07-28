package main

import (
	"cards/duren"

	"log"
	"net/http"

	"github.com/google/uuid"
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
		playerId := r.URL.Query().Get("playerId")
		if playerId == "" {
			log.Println("Missing playerId query parameter")
			http.Error(w, "Missing playerId query parameter", http.StatusBadRequest)
			return
		}

		_, err := uuid.Parse(playerId)
		if err != nil {
			log.Println(err)
			http.Error(w, "Invalid playerId", http.StatusBadRequest)
			return
		}

		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			log.Println(err)
			http.Error(w, "Failed to upgrade connection", http.StatusInternalServerError)
			return
		}

		durenHandler.HandleConnection(conn, playerId)
	})

	log.Fatal(http.ListenAndServe(":8080", r))
}
