package duren

import "cards/cards"

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
