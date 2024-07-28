package duren

import (
	"cards/cards"
	"errors"
	"fmt"
)

const CARDS_AMOUNT_IN_HAND = 6
const MAX_CARD_ROWS_AMOUNT_ON_TABLE = 6

type GameState string

const (
	GameStateWaiting GameState = "waiting" //waiting for players to join and ready
	GameStatePlaying GameState = "playing" //game is in progress
)

type State struct {
	table        *Table
	players      []*Player
	state        GameState
	attaker      *Player
	defender     *Player
	readyPlayers []*Player
}

func NewState() *State {
	return &State{
		table:        nil,
		players:      []*Player{},
		state:        GameStateWaiting,
		attaker:      nil,
		defender:     nil,
		readyPlayers: []*Player{},
	}
}

func (s *State) areAllPlayersReady(playersAmount int) bool {
	return playersAmount == len(s.readyPlayers)
}

func (s *State) isPlayerReady(playerId string) bool {
	for _, p := range s.readyPlayers {
		if p.id == playerId {
			return true
		}
	}

	return false

}

func (s *State) addPlayer(player *Player) error {
	s.players = append(s.players, player)
	return nil
}

func (s *State) removePlayer(playerId string) error {
	var newPlayers []*Player
	for _, p := range s.players {
		if p.id != playerId {
			newPlayers = append(newPlayers, p)
		}
	}
	s.players = newPlayers

	var newReadyPlayers []*Player
	for _, p := range s.readyPlayers {
		if p.id != playerId {
			newReadyPlayers = append(newReadyPlayers, p)
		}
	}
	s.readyPlayers = newReadyPlayers

	return nil
}

func (s *State) confirm() error {
	if s.table.isEmpty() {
		return errors.New("confirm error - table is empty")
	}

	var attaker = s.attaker
	if attaker == nil {
		return errors.New("confirm error - attaker not found")
	}

	if attaker.confirmed {
		return errors.New("confirm error - attaker already confirmed")
	}

	var defender = s.defender
	if defender == nil {
		return errors.New("confirm error - defender not found")
	}

	attaker.confirmed = true
	return nil
}

func (s *State) take(playerId string) error {
	if s.table.isEmpty() {
		return errors.New("table is empty")
	}

	if s.table.areAllCardsCovered() {
		return errors.New("can not take - all cards are covered")
	}

	var defender = s.defender
	if defender == nil {
		return errors.New("take error - defender not found")
	}

	if defender.id != playerId {
		return errors.New("take error - player is not defender")
	}

	if defender.confirmed {
		return errors.New("take error - defender already confirmed")
	}

	var attaker = s.attaker
	if attaker == nil {
		return errors.New("take error - attaker not found")
	}

	defender.confirmed = true

	return nil
}

func (s *State) resetDefenderAndAttaker() {
	//@TODO null check
	if s.defender.confirmed {
		s.attaker = s.findNextReadyPlayerWithCards(s.defender)
		s.defender = s.findNextReadyPlayerWithCards(s.attaker)
	} else {
		if s.defender.hand.len() == 0 {
			s.attaker = s.findNextReadyPlayerWithCards(s.defender)
		} else {
			s.attaker = s.defender
		}
		s.defender = s.findNextReadyPlayerWithCards(s.attaker)
	}
}

func (s *State) clearTable() {
	s.table.clear()
}

func (s *State) tryToEndGame() bool {
	if s.table.deck.Len() > 0 {
		return false
	}

	var newReadyPlayers = []*Player{}
	for _, player := range s.readyPlayers {
		if player.hand.len() == 0 {
			continue
		}
		newReadyPlayers = append(newReadyPlayers, player)
	}

	if len(newReadyPlayers) > 1 {
		s.readyPlayers = newReadyPlayers
		return false
	}

	s.endGame()
	return true
}

func (s *State) endGame() {
	s.readyPlayers = []*Player{}
	s.state = GameStateWaiting
	s.defender = nil
	s.attaker = nil
	s.table = nil

	for _, player := range s.players {
		player.confirmed = false
		player.hand = nil
	}
}

func (s *State) startGame(playersAmount int) bool {
	if !s.areAllPlayersReady(playersAmount) {
		return false
	}

	var deck = cards.NewDeckWithAmount(cards.DeckAmount36)
	s.table = &Table{
		deck:  deck,
		trump: deck.Last(),
		cards: [][]*cards.PlayingCard{},
	}

	//to keep same order of players and ready players - need to copy
	copy(s.readyPlayers, s.players)

	for i, player := range s.readyPlayers {
		player.hand = &Hand{Cards: s.table.deck.Slice(0, CARDS_AMOUNT_IN_HAND)}
		//@TODO set player with lowest trump as attaker
		//@TODO set next as defender
		if i == 0 {
			s.attaker = player
		} else if i == 1 {
			s.defender = player
		}
	}

	s.state = GameStatePlaying
	return true
}

func (s *State) isStateWaiting() bool {
	return s.state == GameStateWaiting
}

func (s *State) isStatePlaying() bool {
	return s.state == GameStatePlaying
}

func (s *State) moveCardsFromTableToDefenderIfDefenderConfirmed() {
	//@TODO check defender
	if !s.defender.confirmed {
		return
	}
	//get all cards from table and add them to player's hand
	for _, row := range s.table.cards {
		s.defender.hand.Cards = append(s.defender.hand.Cards, row...)
	}
}

func (s *State) moveByAttaker(cardId int) error {
	var attaker = s.attaker
	if attaker == nil {
		return errors.New("moveByAttaker error - attaker not found")
	}

	if attaker.confirmed {
		return errors.New("moveByAttaker error - attaker has confirmed")
	}

	var defender = s.defender
	if defender == nil {
		return errors.New("moveByAttaker error - attaker not found")
	}

	card := attaker.hand.findCardById(cardId)
	if card == nil {
		return errors.New("moveByAttaker error - card not found in hand")
	}

	if len(s.table.cards) >= MAX_CARD_ROWS_AMOUNT_ON_TABLE {
		return errors.New("moveByAttaker error - amount of card rows on table is more than 6")
	}

	if !s.table.isEmpty() && !s.table.hasCardOfSameRank(card) {
		return errors.New("moveByAttaker error - card of same rank not found on table")
	}

	if s.table.countNotCoveredCards() >= defender.hand.len() {
		return errors.New("moveByAttaker error - amount of opened cards is more than cards in defender's hand")
	}

	s.table.cards = append(s.table.cards, []*cards.PlayingCard{card})
	attaker.hand.removeCard(card)

	return nil
}

func (s *State) moveByDefender(cardId int, tableIndex *int) error {
	var defender = s.defender
	if defender == nil {
		return errors.New("moveByDefender error - defender not found")
	}

	if defender.confirmed {
		return errors.New("moveByDefender error - defender is taking")
	}

	var attaker = s.attaker
	if attaker == nil {
		return errors.New("moveByAttaker error - attaker not found")
	}

	if s.table.isEmpty() {
		return errors.New("moveByDefender error - table is empty")
	}

	var card = defender.hand.findCardById(cardId)
	if card == nil {
		return fmt.Errorf("moveByDefender error - card not found in hand")
	}

	var cardToCover *cards.PlayingCard
	var index int

	if tableIndex == nil {
		cardToCover, index = s.table.findFirstNotCoveredCardAndIndex()
		if cardToCover == nil {
			return errors.New("moveByDefender error - all cards on table are covered")
		}
	} else {
		index = *tableIndex

		if index < 0 || index >= len(s.table.cards) {
			return errors.New("moveByDefender error - invalid table index")
		}

		if len(s.table.cards[index]) != 1 {
			return fmt.Errorf("moveByDefender error - index %d should have only 1 card", index)
		}
		cardToCover = s.table.cards[index][0]
	}

	if cardToCover.Suit == card.Suit {
		if cardToCover.Rank > card.Rank {
			return errors.New("moveByDefender error - invalid rank")
		}
	} else {
		if card.Suit != s.table.trump.Suit {
			return errors.New("moveByDefender error - invalid suit")
		}
	}

	s.table.cards[index] = append(s.table.cards[index], card)
	defender.hand.removeCard(card)

	return nil
}

func (s *State) canEndRound() bool {
	for _, p := range s.readyPlayers {
		if p == s.defender {
			continue
		}

		if !p.confirmed {
			return false
		}
	}

	return s.defender.confirmed || s.table.areAllCardsCovered()
}

func (s *State) findNextReadyPlayerWithCards(player *Player) *Player {
	var currentPlayerIndex *int
	for index, p := range s.readyPlayers {
		if p == player {
			currentPlayerIndex = &index
		}
	}

	if currentPlayerIndex == nil {
		return nil
	}

	playerCount := len(s.readyPlayers)
	for i := 1; i <= playerCount; i++ {
		nextPlayerIndex := (*currentPlayerIndex + i) % playerCount
		nextPlayer := s.readyPlayers[nextPlayerIndex]
		if nextPlayer.hand.len() > 0 {
			return nextPlayer
		}
	}
	return nil
}

func (s *State) resetPlayerFlags() {
	for _, player := range s.readyPlayers {
		player.confirmed = false
	}
}

func (s *State) setNextAttaker() {
	nextAttaker := s.findNextReadyPlayerWithCards(s.attaker)

	if nextAttaker == s.defender {
		nextAttaker = s.findNextReadyPlayerWithCards(nextAttaker)
	}

	if !nextAttaker.confirmed {
		s.attaker = nextAttaker
	}

}

func (s *State) giveCardsFromDeckToPlayersStaringFromAttaker() {
	var attakerIndex *int
	for index, p := range s.readyPlayers {
		if p == s.attaker {
			attakerIndex = &index
		}
	}

	if attakerIndex == nil {
		return
	}

	playerCount := len(s.readyPlayers)
	for i := 0; i <= playerCount; i++ {
		playerIndex := (*attakerIndex + i) % playerCount
		player := s.readyPlayers[playerIndex]
		for s.table.deck.Len() > 0 && player.hand.len() < CARDS_AMOUNT_IN_HAND {
			player.hand.Cards = append(player.hand.Cards, s.table.deck.Pop())
		}
	}
}

func (s *State) movePlayerToReadyList(id string) error {
	var player *Player

	for _, p := range s.players {
		if p.id == id {
			player = p
		}
	}
	if player == nil {
		return errors.New("player not found")
	}

	for _, p := range s.readyPlayers {
		if player == p {
			return errors.New("player already in ready list")
		}
	}

	s.readyPlayers = append(s.readyPlayers, player)

	return nil
}

func (s *State) getPlayerState(player *Player) PlayerResponseState {
	isPlayerReady := false

	for _, p := range s.readyPlayers {
		if p == player {
			isPlayerReady = true
		}
	}

	if isPlayerReady {
		return PlayerStateReady
	}

	return PlayerStateWaiting
}

func (s *State) getPlayerRole(player *Player) PlayerResponseRole {
	if s.attaker == player {
		return PlayerRoleAttacker
	}

	if s.defender == player {
		return PlayerRoleDefender
	}

	return PlayerRoleIdle
}

func (s *State) canPlayerConfirm(player *Player) bool {
	if player == s.attaker {
		return !player.confirmed && !s.table.isEmpty() && (s.table.areAllCardsCovered() || s.defender.confirmed)
	}

	if player == s.defender {
		return !player.confirmed && !s.table.isEmpty() && !s.table.areAllCardsCovered()
	}

	return false
}

func (s *State) canPlayerMove(player *Player) bool {
	if player == s.attaker {
		return !player.confirmed && len(s.table.cards) < CARDS_AMOUNT_IN_HAND
	}

	if player == s.defender {
		return !player.confirmed && !s.table.isEmpty() && !s.table.areAllCardsCovered()
	}

	return false
}
