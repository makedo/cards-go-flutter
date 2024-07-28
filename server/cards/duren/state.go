package duren

import (
	"cards/cards"
	"errors"
	"fmt"
)

type GameState string

const (
	GameStateWaiting GameState = "waiting"
	GameStatePlaying GameState = "playing"
)

type State struct {
	table   *Table
	players []*Player
	state   GameState
}

func (s *State) findPlayerById(id string) *Player {
	for _, player := range s.players {
		if player.id == id {
			return player
		}
	}
	return nil
}

func (s *State) findPlayingPlayerById(id string) *Player {
	player := s.findPlayerById(id)
	if player != nil && player.state == PlayerStatePlaying {
		return player
	}

	return nil
}

func (s *State) findWaitingOrFinishedPlayerById(id string) *Player {
	player := s.findPlayerById(id)
	if player != nil &&
		(player.state == PlayerStateWaiting ||
			player.state == PlayerStateFinished) {
		return player
	}

	return nil
}

func (s *State) areAllPlayersPlaying(playersAmount int) bool {
	for _, player := range s.players {
		if player.state != PlayerStatePlaying {
			return false
		}
	}

	return playersAmount == len(s.players)
}

func (s *State) addPlayer(id string) {
	s.players = append(s.players, &Player{
		id:         id,
		hand:       nil,
		role:       PlayerRoleIdle,
		canTake:    false,
		canConfirm: false,
		state:      PlayerStateWaiting,
	})
}

func (s *State) findDefender() *Player {
	for _, p := range s.players {
		if p.role == PlayerRoleDefender {
			return p
		}
	}

	return nil
}

func (s *State) canPlayerTake(player *Player) (bool, error) {
	if player.role != PlayerRoleDefender {
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
	if player.role != PlayerRoleAttacker {
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
		for s.table.deck.Len() > 0 && player.hand.len() < 6 {
			player.hand.Cards = append(player.hand.Cards, s.table.deck.Pop())
		}
	}
}

func (s *State) recalculatePlayersRoles() {
	for _, player := range s.players {
		//@todo: for more than 2 players
		if player.role == PlayerRoleAttacker {
			player.role = PlayerRoleDefender
		} else if player.role == PlayerRoleDefender {
			player.role = PlayerRoleAttacker
		}
	}
}

func (s *State) calculatePlayersTakeAndConfirm() {
	for _, player := range s.players {
		player.canTake, _ = s.canPlayerTake(player)
		player.canConfirm, _ = s.canPlayerConfirm(player)
	}
}

func (s *State) clearTable() {
	s.table.clear()
}

func (s *State) endGame() bool {
	if s.table.deck.Len() > 0 {
		return false
	}

	if len(s.table.cards) > 0 {
		return false
	}

	var finishedPlayers = 0
	for _, player := range s.players {
		if player.hand.len() == 0 {
			player.state = PlayerStateFinished
		}

		if player.state == PlayerStateFinished {
			finishedPlayers++
		}
	}

	if finishedPlayers < len(s.players)-1 {
		return false
	}

	var defender = s.findDefender()
	if defender == nil {
		return false
	}
	defender.state = PlayerStateFinished
	s.state = GameStateWaiting
	return true
}

func (s *State) startGame() {
	var deck = cards.NewDeckWithAmount(cards.DeckAmount36)
	s.table = &Table{
		deck:  deck,
		trump: deck.Last(),
		cards: [][]*cards.PlayingCard{},
	}

	for i, player := range s.players {
		player.hand = &Hand{Cards: s.table.deck.Slice(0, 6)}
		//@TODO for more than 2 players
		if i == 0 {
			player.role = PlayerRoleAttacker
		} else {
			player.role = PlayerRoleDefender
		}
	}

	s.state = GameStatePlaying
}

func (s *State) isStateWaiting() bool {
	return s.state == GameStateWaiting
}

func (s *State) isStatePlaying() bool {
	return s.state == GameStatePlaying
}

func (s *State) moveCardsFromTableToPlayer(player *Player) {
	//get all cards from table and add them to player's hand
	for _, row := range s.table.cards {
		player.hand.Cards = append(player.hand.Cards, row...)
	}
}

func (s *State) addCard(player *Player, card *cards.PlayingCard) error {
	if !s.table.isEmpty() {
		if !s.table.hasCardOfSameRank(card) {
			return errors.New("card of same rank not found on table")
		}
	}

	if len(s.table.cards) >= 6 {
		return errors.New("amount of card rows on table is more than 6")
	}

	var defender = s.findDefender()
	if defender == nil {
		return errors.New("defender not found")
	}

	if s.table.countNotCoveredCards() >= defender.hand.len() {
		return errors.New("amount of opened cards is more than cards in defender's hand")
	}

	s.table.cards = append(s.table.cards, []*cards.PlayingCard{card})
	player.hand.removeCard(card)

	return nil
}

func (s *State) coverCard(player *Player, card *cards.PlayingCard, tableIndex *int) error {
	if s.table.isEmpty() {
		return errors.New("can not cover card - table is empty")
	}

	var cardToCover *cards.PlayingCard
	var index int

	if tableIndex == nil {
		cardToCover, index = s.table.findFirstNotCoveredCardAndIndex()
		if cardToCover == nil {
			return fmt.Errorf("all cards on table are covered")
		}
	} else {
		index = *tableIndex

		if index < 0 || index >= len(s.table.cards) {
			return fmt.Errorf("invalid table index")
		}

		if len(s.table.cards[index]) != 1 {
			return fmt.Errorf("index %d should have only 1 card", index)
		}
		cardToCover = s.table.cards[index][0]
	}

	if cardToCover.Suit == card.Suit {
		if cardToCover.Rank > card.Rank {
			return errors.New("invalid rank")
		}
	} else {
		if card.Suit != s.table.trump.Suit {
			return errors.New("invalid suit")
		}
	}

	s.table.cards[index] = append(s.table.cards[index], card)
	player.hand.removeCard(card)

	return nil
}
