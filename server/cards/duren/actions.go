package duren

type ActionType string
const (
	InitActionType    ActionType = "init"
	JoinActionType    ActionType = "join"
	ReadyActionType   ActionType = "ready"
	ConfirmActionType ActionType = "confirm"
	MoveActionType    ActionType = "move"
)

type InitAction struct { //Create a room
	Type ActionType `json:"type"`
	// PlayerId string             `json:"player_id"`
}

type JoinAction struct { //Join a room
	Type     ActionType `json:"type"`
	PlayerId string     `json:"playerId"`
}


type MoveAction struct { //Make a move
	Type       ActionType `json:"type"`
	CardId     int        `json:"cardId"`
	PlayerId   string     `json:"playerId"`
	TableIndex *int       `json:"tableIndex"`
}

type TakeAction struct { //Take the cards
	Type     ActionType `json:"type"`
	PlayerId string     `json:"playerId"`
}

type ConfirmAction struct { //Confirm a move
	Type     ActionType `json:"type"`
	PlayerId string     `json:"playerId"`
}


type ReadyAction struct { //Ready to play
	Type     ActionType `json:"type"`
	PlayerId string     `json:"playerId"`
}


