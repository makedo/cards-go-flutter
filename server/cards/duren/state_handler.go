package duren

import (
	"errors"
	"sync"
)

type StateHandler struct {
	state         State
	playersAmount int
	mutex         sync.Mutex
}

const MAX_PLAYERS = 4

func NewStateHandler(players int) *StateHandler {
	h := &StateHandler{playersAmount: players}
	h.state = *NewState()
	return h
}

func (h *StateHandler) join(action JoinAction) (State, error) {
	h.mutex.Lock()
	defer h.mutex.Unlock()

	if h.state.hasPlayer(action.PlayerId) {
		return h.state, nil
	}

	if !h.state.isStateWaiting() {
		return h.state, errors.New("game is already started")
	}

	if len(h.state.players) >= h.playersAmount {
		return h.state, errors.New("game is full")
	}

	err := h.state.addPlayer(NewPlayer(action.PlayerId))

	return h.state, err
}

func (h *StateHandler) ready(action ReadyAction) (State, error) {
	h.mutex.Lock()
	defer h.mutex.Unlock()

	if !h.state.isStateWaiting() {
		return h.state, errors.New("game is already started")
	}

	err := h.state.movePlayerToReadyList(action.PlayerId)

	if err != nil {
		return h.state, err
	}

	h.state.startGame(h.playersAmount)

	return h.state, nil
}

func (h *StateHandler) move(action MoveAction) (State, error) {
	h.mutex.Lock()
	defer h.mutex.Unlock()

	if !h.state.isStatePlaying() {
		return h.state, errors.New("move error - game is not started")
	}

	if h.state.attaker == nil {
		return h.state, errors.New("move error - attaker not found")
	}

	if h.state.defender == nil {
		return h.state, errors.New("move error - defender not found")
	}

	if h.state.attaker.id == action.PlayerId {
		err := h.state.moveByAttaker(action.CardId)
		if err != nil {
			return h.state, err
		}
	} else if h.state.defender != nil && h.state.defender.id == action.PlayerId {
		err := h.state.moveByDefender(action.CardId, action.TableIndex)
		if err != nil {
			return h.state, err
		}
		h.state.attaker.confirmed = false

	} else {
		return h.state, errors.New("player is not attaker or defender")
	}

	return h.state, nil
}

func (h *StateHandler) take(action TakeAction) (State, error) {
	h.mutex.Lock()
	defer h.mutex.Unlock()

	if !h.state.isStatePlaying() {
		return h.state, errors.New("game is not started")
	}

	err := h.state.take(action.PlayerId)
	if err != nil {
		return h.state, err
	}

	h.state.attaker.confirmed = false

	return h.state, nil
}

func (h *StateHandler) confirm(action ConfirmAction) (State, error) {
	h.mutex.Lock()
	defer h.mutex.Unlock()

	if !h.state.isStatePlaying() {
		return h.state, errors.New("game is not started")
	}

	if h.state.attaker != nil && h.state.attaker.id != action.PlayerId {
		return h.state, errors.New("only attaker can confirm")
	}

	if !h.state.canPlayerConfirm(h.state.attaker) {
		return h.state, errors.New("player can not confirm")
	}

	err := h.state.confirm()
	if err != nil {
		return h.state, err
	}

	//If other players will not able to attak - confirm them automatically
	if len(h.state.table.cards) == 6 || h.state.defender.hand.len() == h.state.table.countNotCoveredCards() {
		for _, p := range h.state.readyPlayers {
			if p == h.state.defender {
				continue
			}
			p.confirmed = true
		}
	}

	if h.state.canEndRound() {
		h.state.moveCardsFromTableToDefenderIfDefenderConfirmed()
		h.state.clearTable()
		h.state.giveCardsFromDeckToPlayersStaringFromAttaker()
		h.state.resetDefenderAndAttaker()
		if !h.state.tryToEndGame() {
			h.state.resetPlayerFlags()
		}
	} else {
		if h.state.defender.confirmed || h.state.table.areAllCardsCovered() {
			h.state.setNextAttaker()
		}
	}

	return h.state, nil
}
