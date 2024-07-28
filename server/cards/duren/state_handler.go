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

	player.state = PlayerStatePlaying
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

	card := player.hand.findCardById(action.CardId)
	if card == nil {
		return h.state, fmt.Errorf("card not found in hand")
	}

	if player.role == PlayerRoleAttacker {
		err := h.state.addCard(player, card)
		if err != nil {
			return h.state, err
		}
	} else if player.role == PlayerRoleDefender {
		err := h.state.coverCard(player, card, action.TableIndex)
		if err != nil {
			return h.state, err
		}
	} else {
		return h.state, errors.New("invalid role")
	}

	h.state.calculatePlayersTakeAndConfirm()
	h.state.endGame()
	return h.state, nil
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
