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

		//check of amount of card rows on table is less or eq 6
		// chek that amount of opene cards
		// is no more than cards in defender's hand
		
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

func (h *StateHandler) take(action TakeAction) (State, error) {
	player := h.state.findPlayerById(action.PlayerId)
	if player == nil {
		return h.state, fmt.Errorf("player not found")
	}

	if player.Role != RoleDefender {
		return h.state, errors.New("only defender can take")
	}

	if h.state.table.isEmpty() {
		return h.state, errors.New("table is empty")
	}

	if !h.state.table.hasNotCoveredCard() {
		return h.state, errors.New("can not take - table has no any rows with more than 1 card")
	}

	//@TODO for more than 2 players

	//get all cards from table
	//add them to player's hand
	for _, row := range h.state.table.cards {
		for _, card := range row {
			player.Hand.Cards = append(player.Hand.Cards, card)

		}
	}
	h.state.table.cards = [][]*cards.PlayingCard{}

	for _, p := range h.state.players {
		for h.state.table.deck.Len() > 0 && p.Hand.len() < 6 {
			p.Hand.Cards = append(p.Hand.Cards, h.state.table.deck.Pop())
		}
	}

	return h.state, nil
}

func (h *StateHandler) confirm(action ConfirmAction) (State, error) {
	player := h.state.findPlayerById(action.PlayerId)
	if player == nil {
		return h.state, fmt.Errorf("player not found")
	}

	if player.Role != RoleAttacker {
		return h.state, errors.New("only attacker can confirm")
	}

	if h.state.table.isEmpty() {
		return h.state, errors.New("table is empty")
	}

	if !h.state.table.areAllCardsCovered() {
		return h.state, errors.New("not all cards are covered")
	}

	//@TODO for more than 2 players

	//clear table
	// change roles
	// give 6 cards to each player
	h.state.table.cards = [][]*cards.PlayingCard{}

	for _, p := range h.state.players {
		if p.Role == RoleAttacker {
			p.Role = RoleDefender
		} else if p.Role == RoleDefender {
			p.Role = RoleAttacker
		}
		for h.state.table.deck.Len() > 0 && p.Hand.len() < 6 {
			p.Hand.Cards = append(p.Hand.Cards, h.state.table.deck.Pop())
		}
	}

	return h.state, nil
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
