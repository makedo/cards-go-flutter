package cards

import "github.com/gorilla/websocket"

type Client struct {
	PlayerId string
	Conn     *websocket.Conn
}

func NewClient(playerId string, conn *websocket.Conn) *Client {
	return &Client{
		PlayerId: playerId,
		Conn:     conn,
	}
}
