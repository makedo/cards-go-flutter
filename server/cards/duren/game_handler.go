package duren

import (
	"log"

	"github.com/davecgh/go-spew/spew"
	"github.com/gorilla/websocket"
	"github.com/mitchellh/mapstructure"
)

type GameHandler struct {
	clients      map[*websocket.Conn]string
	broadcast    chan *State
	stateHandler *StateHandler
}

func NewGameHandler(players int) *GameHandler {
	return &GameHandler{
		clients:      make(map[*websocket.Conn]string),
		broadcast:    make(chan *State),
		stateHandler: NewStateHandler(players),
	}
}

func (h *GameHandler) HandleConnection(conn *websocket.Conn, playerId string) {
	//Limit amount of connections to 10
	h.clients[conn] = playerId

	var state, err = h.stateHandler.join(JoinAction{
		PlayerId: playerId,
	})
	
	if err != nil {
		log.Println(err)
		broadcastState(conn, &state, playerId)
	} else {
		h.broadcast <- &state
	}

	for {
		var data map[string]interface{}
		err := conn.ReadJSON(&data)
		if err != nil {
			log.Printf("error: %v", err)
			broadcastState(conn, &state, playerId)
			break
		}

		// Check the "type" field
		switch data["type"] {
		case "ready":
			var action ReadyAction
			if err := decode(data, &action); err != nil {
				log.Println(err)
				broadcastState(conn, &state, playerId)
				break
			}

			state, err := h.stateHandler.ready(action)
			if err != nil {
				log.Println(err)
				broadcastState(conn, &state, playerId)
				break
			}
			h.broadcast <- &state
		case "move":
			var action MoveAction
			if err := decode(data, &action); err != nil {
				log.Println(err)
				broadcastState(conn, &state, playerId)
				break
			}

			state, err := h.stateHandler.move(action)
			if err != nil {
				log.Println(err)
				broadcastState(conn, &state, playerId)
				break
			}
			h.broadcast <- &state

		case "take":
			var action TakeAction
			if err := decode(data, &action); err != nil {
				log.Println(err)
				broadcastState(conn, &state, playerId)
				break
			}

			state, err := h.stateHandler.take(action)
			if err != nil {
				log.Println(err)
				broadcastState(conn, &state, playerId)
				break
			}
			h.broadcast <- &state
		case "confirm":
			var action ConfirmAction
			if err := decode(data, &action); err != nil {
				log.Println(err)
				break
			}

			state, err := h.stateHandler.confirm(action)
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
		log.Println("Broadcasting state")

		//broadcast message to all clients
		for conn, playerId := range h.clients {
			broadcastState(conn, state, playerId)
		}
	}
}

func broadcastState(client *websocket.Conn, state *State, playerId string) {
	message := response(state, playerId)
	spew.Dump(message)
	writeErr := client.WriteJSON(message)
	if writeErr != nil {
		log.Printf("error: %v", writeErr)
	}
}

func response(state *State, playerId string) *StateResponseMessage {
	var tableResponse *TableResponse
	if state.table != nil {
		tableResponse = &TableResponse{
			Deck:  state.table.deck.Len(),
			Trump: state.table.trump,
			Cards: state.table.cards,
		}
	}

	var me *Player
	startIndex := 0
	for i, player := range state.players {
		if player.id == playerId {
			startIndex = i
			me = player
			break
		}
	}

	var meResponse *MeResponse
	if me == nil {
		meResponse = &MeResponse{
			Id:         playerId,
			Hand:       nil,
			CanConfirm: false,
			State:      PlayerStateWatching,
			Role:       PlayerRoleIdle,
			CanMove:    false,
		}
	} else {
		meResponse = &MeResponse{
			Id:         me.id,
			Hand:       me.hand,
			CanConfirm: state.canPlayerConfirm(me),
			State:      state.getPlayerState(me),
			Role:       state.getPlayerRole(me),
			CanMove:    state.canPlayerMove(me),
		}
	}

	var playerResponses []*PlayerResponse
	j := 0
	for i := startIndex + 1; i < len(state.players); i++ {
		playerResponses = append(playerResponses, &PlayerResponse{
			Hand:  state.players[i].hand.len(),
			Role:  state.getPlayerRole(state.players[i]),
			State: state.getPlayerState(state.players[i]),
		})
		j++
	}
	for i := 0; i < startIndex; i++ {
		playerResponses = append(playerResponses, &PlayerResponse{
			Hand:  state.players[i].hand.len(),
			Role:  state.getPlayerRole(state.players[i]),
			State: state.getPlayerState(state.players[i]),
		})
		j++
	}

	//To return [] instead of null in json
	if playerResponses == nil {
		playerResponses = make([]*PlayerResponse, 0)
	}

	stateResponse := &StateResponse{
		Table:   tableResponse,
		My:      meResponse,
		Players: playerResponses,
		State:   &state.state,
	}

	return newStateResponseMessage(stateResponse)
}

func decode(data map[string]interface{}, result interface{}) error {
	config := &mapstructure.DecoderConfig{
		TagName: "json",
		Result:  result,
	}
	decoder, err := mapstructure.NewDecoder(config)
	if err != nil {
		return err
	}
	if err := decoder.Decode(data); err != nil {
		return err
	}
	return nil
}
