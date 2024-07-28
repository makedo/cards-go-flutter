package duren

import (
	"fmt"
	"sync"
	"testing"
)

func TestStateHandler_join(t *testing.T) {
	h := NewStateHandler(2)
	action := JoinAction{PlayerId: "player1"}

	// Test joining with a new player
	state, err := h.join(action)
	if err != nil {
		t.Errorf("Unexpected error: %v", err)
	}
	if len(state.players) != 1 {
		t.Errorf("Expected 1 player, got %d", len(state.players))
	}

	// Test joining with the same player again
	state, err = h.join(action)
	if err == nil {
		t.Error("Expected error when the same player joins again, got nil")
	}

	// Test joining with a new player
	action = JoinAction{PlayerId: "player2"}
	state, err = h.join(action)
	if err != nil {
		t.Errorf("Unexpected error: %v", err)
	}
	if len(state.players) != 2 {
		t.Errorf("Expected 2 players, got %d", len(state.players))
	}

	// Test joining with a third player when the game is full
	action = JoinAction{PlayerId: "player3"}
	state, err = h.join(action)
	if err == nil {
		t.Error("Expected error when a third player joins a full game, got nil")
	}
}

func TestStateHandler_join_concurrent(t *testing.T) {
	h := NewStateHandler(10)
	var wg sync.WaitGroup

	for i := 0; i < 10; i++ {
		wg.Add(1)
		go func(i int) {
			defer wg.Done()
			_, err := h.join(JoinAction{PlayerId: fmt.Sprintf("player%d", i)})
			if err != nil {
				t.Errorf("join failed: %v", err)
			}
		}(i)
	}

	wg.Wait()

	if len(h.state.players) != 10 {
		t.Errorf("expected 10 players, got %d", len(h.state.players))
	}
}

func TestStateHandler_ready(t *testing.T) {
	h := NewStateHandler(2)

	for _, id := range []string{"player1", "player2"} {
		h.join(JoinAction{PlayerId: id})
	}

	action := ReadyAction{PlayerId: "player1"}
	state, err := h.ready(action)
	if err != nil {
		t.Errorf("Unexpected error: %v", err)
	}
	if len(state.readyPlayers) != 1 {
		t.Errorf("Expected 1 ready player, got %d", len(state.readyPlayers))
	}

	action = ReadyAction{PlayerId: "player1"}
	state, err = h.ready(action)
	if err == nil {
		t.Error("Expected error when the same player is ready again, got nil")
	}

	//All players are ready
	action = ReadyAction{PlayerId: "player2"}
	state, err = h.ready(action)
	if err != nil {
		t.Errorf("Unexpected error: %v", err)
	}
	if len(state.readyPlayers) != 2 {
		t.Errorf("Expected 2 ready players, got %d", len(state.readyPlayers))
	}

	if state.state != GameStatePlaying {
		t.Errorf("Expected state to be playing, got %s", state.state)
	}

	if state.table == nil {
		t.Errorf("Expected table to be not nil, got nil")
	}
}

func TestStateHandler_ready_concurrent(t *testing.T) {
	h := NewStateHandler(MAX_PLAYERS)
	var wg sync.WaitGroup

	for i := 0; i < MAX_PLAYERS; i++ {
		h.join(JoinAction{PlayerId: fmt.Sprintf("player%d", i)})
	}

	for i := 0; i < MAX_PLAYERS; i++ {
		wg.Add(1)
		go func(i int) {
			defer wg.Done()
			_, err := h.ready(ReadyAction{PlayerId: fmt.Sprintf("player%d", i)})
			if err != nil {
				t.Errorf("ready failed: %v", err)
			}
		}(i)
	}

	wg.Wait()

	if len(h.state.readyPlayers) != MAX_PLAYERS {
		t.Errorf("expected 10 ready players, got %d", len(h.state.readyPlayers))
	}

	if h.state.state != GameStatePlaying {
		t.Errorf("Expected state to be playing, got %s", h.state.state)
	}

	if h.state.table == nil {
		t.Errorf("Expected table to be not nil, got nil")
	}
}
