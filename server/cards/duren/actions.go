package duren

type ActionType string

const (
	JoinActionType      ActionType = "join"
	ReadyActionType     ActionType = "ready"
	MoveActionType      ActionType = "move"
	ConfirmActionType   ActionType = "confirm"
	TakeActionType      ActionType = "take"
	LeaveActionType     ActionType = "leave"
	WillLeaveActionType ActionType = "willLeave"
)

type JoinAction struct { //Join a room
	Type     ActionType `json:"type"`
	PlayerId string     `json:"playerId"`
}

type ReadyAction struct { //Start playing
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

type LeaveAction struct { //Confirm a move
	Type     ActionType `json:"type"`
	PlayerId string     `json:"playerId"`
}
