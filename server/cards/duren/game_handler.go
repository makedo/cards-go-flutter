package duren

import (
	"log"

	"github.com/google/uuid"
	"github.com/gorilla/websocket"
	"github.com/mitchellh/mapstructure"
)

type GameHandler struct {
	clients      map[string]*websocket.Conn
	broadcast    chan *State
	stateHandler *StateHandler
}

func NewGameHandler(players int) *GameHandler {
	return &GameHandler{
		clients:      make(map[string]*websocket.Conn),
		broadcast:    make(chan *State),
		stateHandler: NewStateHandler(players),
	}
}

func (h *GameHandler) HandleConnection(conn *websocket.Conn) {
	var playerId = uuid.New().String()
	h.clients[playerId] = conn

	state := h.stateHandler.join(JoinAction{
		PlayerId: playerId,
	})
	h.broadcast <- &state

	for {
		var data map[string]interface{}
		err := conn.ReadJSON(&data)
		if err != nil {
			log.Printf("error: %v", err)
			break
		}

		// Check the "type" field
		switch data["type"] {
		case "move":
			var action MoveAction

			config := &mapstructure.DecoderConfig{
				TagName: "json",
				Result:  &action,
			}

			decoder, err := mapstructure.NewDecoder(config)
			if err != nil {
				log.Println(err)
				break
			}

			if err := decoder.Decode(data); err != nil {
				log.Println(err)
				break
			}

			state, err := h.stateHandler.move(action)
			if err != nil {
				log.Println(err)
				break
			}

			h.broadcast <- &state

		// Add more cases as needed...
		default:
			log.Printf("Unknown type: %v", data["type"])
		}
	}
}

func (h *GameHandler) BroadcastState() {
	for {
		state := <-h.broadcast
		log.Println(state)

		// msg, jsonErr := json.Marshal(message)
		// if jsonErr != nil {
		// 	log.Println(jsonErr)
		// 	return
		// }

		//broadcast message to all clients
		for playerId, client := range h.clients {
			message := h.response(state, playerId)
			writeErr := client.WriteJSON(message)
			if writeErr != nil {
				log.Printf("error: %v", writeErr)
			}
		}
	}
}

func (h *GameHandler) response(state *State, playerId string) *StateResponseMessage {
	var me *MeResponse
	var top *PlayerResponse

	for _, player := range state.players {
		if player.Id == playerId {
			me = &MeResponse{
				Id:   player.Id,
				Hand: player.Hand,
				Role: player.Role,
			}
		} else {
			top = &PlayerResponse{
				Hand: player.Hand.len(),
				Role: player.Role,
			}
		}
	}

	responseState := &StateResponse{
		Table: &TableResponse{
			Deck:  state.table.deck.Len(),
			Trump: state.table.trump,
			Cards: state.table.cards,
		},
		My: me,
		Players: &PlayersResponse{
			Top: top,
		},
	}

	return newStateResponseMessage(responseState)
}
