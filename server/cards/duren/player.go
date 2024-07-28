package duren

type Player struct {
	id         string
	hand       *Hand
	role       PlayerRole
	canTake    bool
	canConfirm bool
	state      PlayerState
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
