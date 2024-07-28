package duren

import (
	"errors"
	"fmt"
)

type StateHandler struct {
	state   State
	players int
}

func NewStateHandler(players int) *StateHandler {
	h := &StateHandler{players: players}
	h.state = State{
		table:   nil,
		state:   GameStateWaiting,
		players: []*Player{},
	}

	return h
}

func (h *StateHandler) join(action JoinAction) (State, error) {
	if !h.state.isStateWaiting() {
		return h.state, errors.New("game is already started")
	}

	if len(h.state.players) >= h.players {
		return h.state, errors.New("game is full")
	}

	h.state.addPlayer(action.PlayerId)

	return h.state, nil
}

func (h *StateHandler) ready(action ReadyAction) (State, error) {
	if !h.state.isStateWaiting() {
		return h.state, errors.New("game is already started")
	}

	player := h.state.findWaitingOrFinishedPlayerById(action.PlayerId)
	if player == nil {
		return h.state, fmt.Errorf("player with waiting state not found")
	}

	player.State = PlayerStatePlaying
	if h.state.areAllPlayersPlaying(h.players) {
		h.state.startGame()
	}

	return h.state, nil
}

func (h *StateHandler) move(action MoveAction) (State, error) {
	if !h.state.isStatePlaying() {
		return h.state, errors.New("game is not started")
	}

	player := h.state.findPlayingPlayerById(action.PlayerId)
	if player == nil {
		return h.state, fmt.Errorf("player with playing state not found")
	}

	card := player.Hand.findCardById(action.CardId)
	if card == nil {
		return h.state, fmt.Errorf("card not found in hand")
	}

	var table = h.state.table

	if player.Role == PlayerRoleAttacker {
		if !table.isEmpty() {
			if !table.hasCardOfSameRank(card) {
				return h.state, errors.New("card of same rank not found on table")
			}
		}

		if len(table.cards) >= 6 {
			return h.state, errors.New("amount of card rows on table is more than 6")
		}

		var defender = h.state.findDefender()

		if defender == nil {
			return h.state, errors.New("defender not found")
		}

		if table.countNotCoveredCards() >= defender.Hand.len() {
			return h.state, errors.New("amount of opened cards is more than cards in defender's hand")
		}

		table.addCard(card)
		player.Hand.removeCard(card)

		h.state.calculatePlayersTakeAndConfirm()
		h.state.endGame()

		return h.state, nil
	}

	if player.Role == PlayerRoleDefender {

		if table.isEmpty() {
			return h.state, errors.New("defender can not move card - table is empty")
		}

		var index int
		if (action.TableIndex == nil) || (*action.TableIndex < 0) {
			index = len(table.cards) - 1
		} else {
			index = *action.TableIndex
		}

		if index >= len(table.cards) {
			return h.state, fmt.Errorf("invalid table index")
		}

		if len(table.cards[index]) != 1 {
			return h.state, fmt.Errorf("index %d should have only 1 card", index)
		}

		var cardToCover = table.cards[index][0]

		if cardToCover.Suit == card.Suit {
			if cardToCover.Rank > card.Rank {
				return h.state, errors.New("invalid rank")
			}
		} else {
			if card.Suit != table.trump.Suit {
				return h.state, errors.New("invalid suit")
			}
		}

		table.coverCard(card, index)
		player.Hand.removeCard(card)

		h.state.calculatePlayersTakeAndConfirm()
		h.state.endGame()

		return h.state, nil
	}

	return h.state, errors.New("invalid role")
}

func (h *StateHandler) take(action TakeAction) (State, error) {
	if !h.state.isStatePlaying() {
		return h.state, errors.New("game is not started")
	}

	player := h.state.findPlayingPlayerById(action.PlayerId)
	if player == nil {
		return h.state, fmt.Errorf("player with playing state not found")
	}

	var canTake, err = h.state.canPlayerTake(player)
	if !canTake {
		return h.state, err
	}

	h.state.moveCardsFromTableToPlayer(player)

	h.state.clearTable()
	h.state.giveCardsFromDeckToPlayers()
	h.state.calculatePlayersTakeAndConfirm()
	h.state.endGame()

	return h.state, nil
}

func (h *StateHandler) confirm(action ConfirmAction) (State, error) {
	if !h.state.isStatePlaying() {
		return h.state, errors.New("game is not started")
	}

	player := h.state.findPlayingPlayerById(action.PlayerId)
	if player == nil {
		return h.state, fmt.Errorf("player with playing state not found")
	}

	var canConfirm, err = h.state.canPlayerConfirm(player)
	if !canConfirm {
		return h.state, err
	}

	h.state.clearTable()
	h.state.giveCardsFromDeckToPlayers()
	h.state.recalculatePlayersRoles()
	h.state.calculatePlayersTakeAndConfirm()
	h.state.endGame()

	return h.state, nil
}
