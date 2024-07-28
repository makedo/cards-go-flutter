package duren

type Player struct {
	Id         string      `json:"id"`
	Hand       *Hand       `json:"hand"`
	Role       PlayerRole  `json:"role"`
	CanTake    bool        `json:"canTake"`
	CanConfirm bool        `json:"canConfirm"`
	State      PlayerState `json:"state"`
}

type PlayerRole string

const (
	PlayerRoleAttacker PlayerRole = "attacker"
	PlayerRoleDefender PlayerRole = "defender"
	PlayerRoleIdle     PlayerRole = "idle"
)

type PlayerState string

const (
	PlayerStateWaiting  PlayerState = "waiting"
	PlayerStatePlaying  PlayerState = "playing"
	PlayerStateFinished PlayerState = "finished"
	PlayerStateLeft     PlayerState = "left"
)
