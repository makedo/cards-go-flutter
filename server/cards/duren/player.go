package duren

type Player struct {
	id        string
	hand      *Hand
	confirmed bool
}

func NewPlayer(id string) *Player {
	return &Player{
		id:        id,
		hand:      nil,
		confirmed: false,
	}
}
