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
	Table   *TableResponse    `json:"table"`
	My      *MeResponse       `json:"my"`
	Players []*PlayerResponse `json:"players"`
	State   *GameState        `json:"state"`
}

type PlayerResponseRole string

const (
	PlayerRoleAttacker PlayerResponseRole = "attacker"
	PlayerRoleDefender PlayerResponseRole = "defender"
	PlayerRoleIdle     PlayerResponseRole = "idle"
)

type PlayerResponseState string

const (
	PlayerStateWaiting PlayerResponseState = "waiting"
	PlayerStateReady   PlayerResponseState = "ready"
)

type PlayerResponse struct {
	Hand  int                 `json:"hand"`
	Role  PlayerResponseRole  `json:"role"`
	State PlayerResponseState `json:"state"`
}

type TableResponse struct {
	Deck  int                    `json:"deck"`
	Trump *cards.PlayingCard     `json:"trump"`
	Cards [][]*cards.PlayingCard `json:"cards"`
}

type MeResponse struct {
	Id         string              `json:"id"`
	Hand       *Hand               `json:"hand"`
	Role       PlayerResponseRole  `json:"role"`
	CanConfirm bool                `json:"canConfirm"`
	CanMove    bool                `json:"canMove"`
	State      PlayerResponseState `json:"state"`
}
