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
	PlayerId string     `json:"player_id"`
}

type ReadyAction struct { //Ready to play
	Type     ActionType `json:"type"`
	PlayerId string     `json:"player_id"`
}

type MoveAction struct { //Make a move
	Type       ActionType `json:"type"`
	CardId     int        `json:"card_id"`
	PlayerId   string     `json:"player_id"`
	TableIndex *int       `json:"table_index"`
}

type ConfirmAction struct { //Confirm a move
	Type     ActionType `json:"type"`
	PlayerId string     `json:"player_id"`
}
