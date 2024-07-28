package cards

import (
	"math/rand"
)

var allCards []*PlayingCard = initAllCards()

func initAllCards() []*PlayingCard {
	var allCards []*PlayingCard
	var id = 1

	for _, suit := range SuitList {
		for rank := RankTwo; rank <= RankAce; rank++ {
			allCards = append(allCards, newPlayingCard(id, suit, rank))
			id++
		}
	}
	return allCards
}

type Deck struct {
	Cards []*PlayingCard `json:"cards"`
}

func newDeck(cards []*PlayingCard) *Deck {
	rand.Shuffle(len(cards), func(i, j int) {
		cards[i], cards[j] = cards[j], cards[i]
	})

	return &Deck{
		Cards: cards,
	}
}

func NewDeck52() *Deck {
	cards := make([]*PlayingCard, 52)

	copy(cards, allCards)

	return newDeck(cards)
}

func NewDeck36() *Deck {
	const minRank = RankSix
	cards := make([]*PlayingCard, 36)

	var i = 0
	for _, card := range allCards {
		if card.Rank >= minRank {
			cards[i] = card
			i++
		}
	}

	return newDeck(cards)
}

func (d *Deck) Last() *PlayingCard {
	return d.Cards[len(d.Cards)-1]
}

func (d *Deck) Len() int {
	return len(d.Cards)
}

func (d *Deck) Slice(start, end int) []*PlayingCard {
	slicedCards := make([]*PlayingCard, end-start)
	copy(slicedCards, d.Cards[start:end])
	d.Cards = d.Cards[end:]
	return slicedCards
}

func (d *Deck) Pop() *PlayingCard {
	return d.Slice(0, 1)[0]
}
