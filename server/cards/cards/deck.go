package cards

import (
	"math/rand"
)

type DeckAmount int

const DeckAmount4 DeckAmount = 4
const DeckAmount8 DeckAmount = 8
const DeckAmount12 DeckAmount = 12
const DeckAmount16 DeckAmount = 16
const DeckAmount20 DeckAmount = 20
const DeckAmount24 DeckAmount = 24
const DeckAmount28 DeckAmount = 28
const DeckAmount32 DeckAmount = 32
const DeckAmount36 DeckAmount = 36
const DeckAmount40 DeckAmount = 40
const DeckAmount44 DeckAmount = 44
const DeckAmount48 DeckAmount = 48
const DeckAmount52 DeckAmount = 52

var minRanksForDeckAmounts = map[DeckAmount]Rank{
	DeckAmount52: RankTwo,
	DeckAmount48: RankThree,
	DeckAmount44: RankFour,
	DeckAmount40: RankFive,
	DeckAmount36: RankSix,
	DeckAmount32: RankSeven,
	DeckAmount28: RankEight,
	DeckAmount24: RankNine,
	DeckAmount20: RankTen,
	DeckAmount16: RankJack,
	DeckAmount12: RankQueen,
	DeckAmount8:  RankKing,
	DeckAmount4:  RankAce,
}

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

var allCards []*PlayingCard = initAllCards()

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

func NewDeckWithAmount(amount DeckAmount) *Deck {
	minRank := minRanksForDeckAmounts[amount]
	cards := make([]*PlayingCard, amount)

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
