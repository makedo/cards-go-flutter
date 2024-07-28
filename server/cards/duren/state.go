package duren

import (
	"errors"
)

type State struct {
	table   Table
	players []*Player
}

func (s *State) findPlayerById(id string) *Player {
	for _, player := range s.players {
		if player.Id == id {
			return player
		}
	}
	return nil
}

func (s *State) areAllPlayersReady() bool {
	for _, player := range s.players {
		if !player.Ready {
			return false
		}
	}

	return true
}

func (s *State) findDefender() *Player {
	for _, p := range s.players {
		if p.Role == RoleDefender {
			return p
		}
	}

	return nil
}

func (s *State) canPlayerTake(player *Player) (bool, error) {
	if player.Role != RoleDefender {
		return false, errors.New("only defender can take")
	}

	if s.table.isEmpty() {
		return false, errors.New("table is empty")
	}

	if s.table.areAllCardsCovered() {
		return false, errors.New("can not take - all cards are covered")
	}

	return true, nil
}

func (s *State) canPlayerConfirm(player *Player) (bool, error) {
	if player.Role != RoleAttacker {
		return false, errors.New("only attacker can confirm")
	}

	if s.table.isEmpty() {
		return false, errors.New("table is empty")
	}

	if !s.table.areAllCardsCovered() {
		return false, errors.New("not all cards are covered")
	}

	return true, nil
}

func (s *State) giveCardsFromDeckToPlayers() {
	for _, player := range s.players {
		for s.table.deck.Len() > 0 && player.Hand.len() < 6 {
			player.Hand.Cards = append(player.Hand.Cards, s.table.deck.Pop())
		}
	}
}

func (s *State) recalculatePlayersRoles() {
	for _, player := range s.players {
		//@todo: for more than 2 players
		if player.Role == RoleAttacker {
			player.Role = RoleDefender
		} else if player.Role == RoleDefender {
			player.Role = RoleAttacker
		}
	}
}

func (s *State) calculatePlayersTakeAndConfirm() {
	for _, player := range s.players {
		player.CanTake, _ = s.canPlayerTake(player)
		player.CanConfirm, _ = s.canPlayerConfirm(player)
	}
}

func (s *State) clearTable() {
	s.table.clear()
}

type Player struct {
	Id         string `json:"id"`
	Hand       *Hand  `json:"hand"`
	Role       Role   `json:"role"`
	Ready      bool   `json:"ready"`
	CanTake    bool   `json:"canTake"`
	CanConfirm bool   `json:"canConfirm"`
}

type Role string

const (
	RoleAttacker Role = "attacker"
	RoleDefender Role = "defender"
	RoleIdle     Role = "idle"
)
