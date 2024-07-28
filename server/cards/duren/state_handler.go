package duren

import (
	"cards/cards"
	"errors"
	"fmt"
)

type StateHandler struct {
	state   State
	players int
}

func NewStateHandler(players int) *StateHandler {
	h := &StateHandler{players: players}

	var deck = cards.NewDeck36()

	h.state = State{
		table: Table{
			deck:  deck,
			trump: deck.Last(),
			cards: [][]*cards.PlayingCard{},
		},
		players: []*Player{},
	}

	return h
}

func (h *StateHandler) join(action JoinAction) State {
	var defineRole = func() Role {
		switch len(h.state.players) {
		case 0:
			return RoleAttacker
		case 1:
			return RoleDefender
		default:
			return RoleIdle
		}
	}

	var player = &Player{
		Id:    action.PlayerId,
		Hand:  &Hand{Cards: h.state.table.deck.Slice(0, 6)},
		Role:  defineRole(),
		Ready: false,
	}

	h.state.players = append(h.state.players, player)

	return h.state
}

func (h *StateHandler) ready(playerId string) State {
	player := h.state.findPlayerById(playerId)
	player.Ready = true

	if h.state.areAllPlayersReady() {
		h.start()
	}

	return h.state
}

func (h *StateHandler) start() State {
	for i, player := range h.state.players {
		player.Hand = &Hand{Cards: h.state.table.deck.Slice(0, 6)}
		if i == 0 {
			player.Role = RoleAttacker
		} else {
			player.Role = RoleDefender
		}
	}

	return h.state
}

// @TODO error handling
func (h *StateHandler) move(action MoveAction) (State, error) {
	player := h.state.findPlayerById(action.PlayerId)
	if player == nil {
		return h.state, fmt.Errorf("player not found")
	}

	card := player.Hand.findCardById(action.CardId)
	if card == nil {
		return h.state, fmt.Errorf("card not found in hand")
	}

	var table = &h.state.table

	if player.Role == RoleAttacker {

		if !table.isEmpty() {
			if !table.hasCardOfSameRank(card) {
				return h.state, errors.New("card of same rank not found on table")
			}
		}

		table.addCard(card)
		player.Hand.removeCard(card)

		return h.state, nil
	}

	if player.Role == RoleDefender {

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

		return h.state, nil
	}

	return h.state, errors.New("invalid role")
}
