package duren

import "cards/cards"

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
	var player = &Player{
		Id:    action.PlayerId,
		Hand:  &Hand{Cards: h.state.table.deck.Slice(0, 6)},
		Role:  RoleIdle,
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
func (h *StateHandler) move(action MoveAction) State {
	player := h.state.findPlayerById(action.PlayerId)

	if player == nil {
		return h.state
	}

	if player.Role == RoleAttacker {
		card := player.Hand.RemoveCardById(action.CardId)
		if card == nil {
			return h.state
		}
		h.state.table.addCard(card)

		return h.state
	}

	if player.Role == RoleDefender {
		return h.state
	}

	return h.state
}
