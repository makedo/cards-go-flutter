package cards

type Suit string

const (
	Spades   Suit = "spades"
	Clubs    Suit = "clubs"
	Hearts   Suit = "hearts"
	Diamonds Suit = "diamonds"
)

var SuitList = []Suit{Spades, Clubs, Hearts, Diamonds}

type Rank uint8

const RankTwo Rank = 2
const RankThree Rank = 3
const RankFour Rank = 4
const RankFive Rank = 5
const RankSix Rank = 6
const RankSeven Rank = 7
const RankEight Rank = 8
const RankNine Rank = 9
const RankTen Rank = 10
const RankJack Rank = 11
const RankQueen Rank = 12
const RankKing Rank = 13
const RankAce Rank = 14

type PlayingCard struct {
	Id   int  `json:"id"`
	Suit Suit `json:"suit"`
	Rank Rank `json:"rank"`
}

func newPlayingCard(id int, suit Suit, rank Rank) *PlayingCard {
	return &PlayingCard{
		Id:   id,
		Suit: suit,
		Rank: rank,
	}
}
