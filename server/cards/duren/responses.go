package duren

import (
	"cards/cards"
)

type StateResponseMessage struct { //State of the game
	Type  string         `json:"type"`
	State *StateResponse `json:"state"`
}

func newStateResponseMessage(responseState *StateResponse) *StateResponseMessage {
	return &StateResponseMessage{
		Type:  "state",
		State: responseState,
	}
}

type StateResponse struct {
	Table   *TableResponse   `json:"table"`
	My      *MeResponse      `json:"my"`
	Players *PlayersResponse `json:"players"`
	State   *GameState       `json:"state"`
}

type PlayerResponse struct {
	Hand int        `json:"hand"`
	Role PlayerRole `json:"role"`
}

type PlayersResponse struct {
	Top   *PlayerResponse `json:"top,omitempty"`
	Left  *PlayerResponse `json:"left,omitempty"`
	Right *PlayerResponse `json:"right,omitempty"`
}

type TableResponse struct {
	Deck  int                    `json:"deck"`
	Trump *cards.PlayingCard     `json:"trump"`
	Cards [][]*cards.PlayingCard `json:"cards"`
}

type MeResponse struct {
	Id         string      `json:"id"`
	Hand       *Hand       `json:"hand"`
	Role       PlayerRole  `json:"role"`
	CanTake    bool        `json:"canTake"`
	CanConfirm bool        `json:"canConfirm"`
	State      PlayerState `json:"state"`
}
