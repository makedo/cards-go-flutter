package duren

import (
	"cards/cards"
	"errors"
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
		if player.Id == id {
			return player
		}
	}
	return nil
}

func (s *State) findPlayingPlayerById(id string) *Player {
	player := s.findPlayerById(id)
	if player != nil && player.State == PlayerStatePlaying {
		return player
	}

	return nil
}

func (s *State) findWaitingOrFinishedPlayerById(id string) *Player {
	player := s.findPlayerById(id)
	if player != nil &&
		(player.State == PlayerStateWaiting ||
			player.State == PlayerStateFinished) {
		return player
	}

	return nil
}

func (s *State) areAllPlayersPlaying(playersAmount int) bool {
	for _, player := range s.players {
		if player.State != PlayerStatePlaying {
			return false
		}
	}

	return playersAmount == len(s.players)
}

func (s *State) addPlayer(id string) {
	s.players = append(s.players, &Player{
		Id:         id,
		Hand:       nil,
		Role:       PlayerRoleIdle,
		CanTake:    false,
		CanConfirm: false,
		State:      PlayerStateWaiting,
	})
}

func (s *State) findDefender() *Player {
	for _, p := range s.players {
		if p.Role == PlayerRoleDefender {
			return p
		}
	}

	return nil
}

func (s *State) canPlayerTake(player *Player) (bool, error) {
	if player.Role != PlayerRoleDefender {
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
	if player.Role != PlayerRoleAttacker {
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
		if player.Role == PlayerRoleAttacker {
			player.Role = PlayerRoleDefender
		} else if player.Role == PlayerRoleDefender {
			player.Role = PlayerRoleAttacker
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

func (s *State) endGame() bool {
	if s.table.deck.Len() > 0 {
		return false
	}

	if len(s.table.cards) > 0 {
		return false
	}

	var finishedPlayers = 0
	for _, player := range s.players {
		if player.Hand.len() == 0 {
			player.State = PlayerStateFinished
		}

		if player.State == PlayerStateFinished {
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
	defender.State = PlayerStateFinished

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
		player.Hand = &Hand{Cards: s.table.deck.Slice(0, 6)}
		//@TODO for more than 2 players
		if i == 0 {
			player.Role = PlayerRoleAttacker
		} else {
			player.Role = PlayerRoleDefender
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
		player.Hand.Cards = append(player.Hand.Cards, row...)
	}
}
