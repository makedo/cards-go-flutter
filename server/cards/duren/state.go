package duren

import (
	"cards/cards"
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

type Table struct {
	deck  *cards.Deck
	trump *cards.PlayingCard
	cards [][]*cards.PlayingCard
}

func (t *Table) addCard(card *cards.PlayingCard) {
	t.cards = append(t.cards, []*cards.PlayingCard{card})
}

func (t *Table) coverCard(card *cards.PlayingCard, index int) {
	t.cards[index] = append(t.cards[index], card)
}

func (t *Table) isEmpty() bool {
	return len(t.cards) == 0
}

func (t *Table) hasCardOfSameRank(card *cards.PlayingCard) bool {
	for _, row := range t.cards {
		for _, cardOnTable := range row {
			if cardOnTable.Rank == card.Rank {
				return true
			}
		}
	}

	return false
}

type Player struct {
	Id    string `json:"id"`
	Hand  *Hand  `json:"hand"`
	Role  Role   `json:"role"`
	Ready bool   `json:"ready"`
}

type Role string

const (
	RoleAttacker Role = "attacker"
	RoleDefender Role = "defender"
	RoleIdle     Role = "idle"
)
