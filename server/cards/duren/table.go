package duren

import (
	"cards/cards"
)

type Table struct {
	deck  *cards.Deck
	trump *cards.PlayingCard
	cards [][]*cards.PlayingCard
}

func (t *Table) clear() {
	t.cards = [][]*cards.PlayingCard{}
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

func (t *Table) areAllCardsCovered() bool {
	for _, row := range t.cards {
		if len(row) == 1 {
			return false
		}
	}

	return true
}

func (t *Table) countNotCoveredCards() int {
	var count = 0
	for _, row := range t.cards {
		if len(row) == 1 {
			count++
		}
	}

	return count
}

func (t *Table) findFirstNotCoveredCardAndIndex() (*cards.PlayingCard, int) {
	for i, row := range t.cards {
		if len(row) == 1 {
			return row[0], i
		}
	}

	return nil, 0
}
