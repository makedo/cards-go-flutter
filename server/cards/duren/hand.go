package duren

import "cards/cards"

type Hand struct {
	Cards []*cards.PlayingCard `json:"cards"`
}

func (h *Hand) len() int {
	return len(h.Cards)
}

func (h *Hand) removeCard(cardToRemove *cards.PlayingCard) {
	for i, card := range h.Cards {
		if card == cardToRemove {
			h.Cards = append(h.Cards[:i], h.Cards[i+1:]...)
		}
	}

	return
}

func (h *Hand) findCardById(id int) *cards.PlayingCard {
	for _, card := range h.Cards {
		if card.Id == id {
			return card
		}
	}
	return nil
}
