import 'dart:convert';

import 'package:cards/config/config.dart';
import 'package:cards/games/duren/models/duren_state.dart';
import 'package:cards/models/playing_card.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:cards/widgets/playing_hand_other_widget.dart';
import 'package:cards/widgets/playing_hand_my_widget.dart';
import 'package:cards/games/duren/widgets/duren_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DurenGame extends StatefulWidget {
  const DurenGame({super.key});

  @override
  State<DurenGame> createState() => _DurenGameState();
}

class _DurenGameState extends State<DurenGame> {
  final _channel = WebSocketChannel.connect(
    Uri.parse(Config.wsUrl),
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }

        final serverMessage = jsonDecode(snapshot.data);
        final durenState = DurenState.fromJson(serverMessage['state']);

        return Column(
          children: [
            PlayingHandOtherWidgetContainer(
              rotated: false,
              child: PlayingHandOtherTopWidget(
                cardsAmount: durenState.players.topPlayerCards,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  PlayingHandOtherWidgetContainer(
                    rotated: true,
                    child: PlayingHandOtherLeftWidget(
                      cardsAmount: durenState.players.leftPlayerCards,
                    ),
                  ),
                  Expanded(
                    child: DragTarget<PlayingCard>(
                        builder: (context, candidateData, rejectedData) =>
                            DurenTableWidget(
                              table: durenState.table,
                              onDragWillAccept: _onDragWillAccept,
                              onDragLeave: _onDragLeave,
                              onDragAccept: _onDragAccept(durenState),
                            ),
                        onWillAcceptWithDetails: _onDragWillAccept,
                        onLeave: _onDragLeave,
                        onAcceptWithDetails:
                            (DragTargetDetails<PlayingCard> details) =>
                                _onDragAccept(durenState)(details.data, null)),
                  ),
                  PlayingHandOtherWidgetContainer(
                    rotated: true,
                    child: PlayingHandOtherRightWidget(
                      cardsAmount: durenState.players.rightPlayerCards,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey,
              height: PlayingCardWidget.height,
              child: PlayingHandMyWidget(
                cards: durenState.my.hand.cards,
              ),
            ),
          ],
        );
      },
    );
  }

  Function _onDragAccept(DurenState durenState) {
    return (PlayingCard card, int? index) {
      var message = {
        'type': 'move',
        'card_id': card.id,
        'player_id': durenState.my.id,
        'table_index': index,
      };

      // Convert the message to a JSON string
      var messageJson = jsonEncode(message);

      // Send the message to the WebSocket
      _channel.sink.add(messageJson);

      // durenState.my.hand.remove(card);
      // durenState.table.add(card, index);
      // setState(() => durenState = durenState);
    };
  }

  void _onDragLeave(PlayingCard? card) {}

  bool _onDragWillAccept(DragTargetDetails<PlayingCard> details) {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
  }
}

class PlayingHandOtherRightWidget extends StatelessWidget {
  const PlayingHandOtherRightWidget({
    super.key,
    required this.cardsAmount,
  });

  final int cardsAmount;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minWidth: 0.0,
      maxWidth: PlayingCardWidget.width,
      alignment: Alignment.topLeft,
      child: PlayingHandOtherWidget(
        cardsAmount: cardsAmount,
        rotated: true,
      ),
    );
  }
}

class PlayingHandOtherLeftWidget extends StatelessWidget {
  const PlayingHandOtherLeftWidget({
    super.key,
    required this.cardsAmount,
  });

  final int cardsAmount;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minWidth: 0.0,
      maxWidth: PlayingCardWidget.width,
      alignment: Alignment.topRight,
      child: PlayingHandOtherWidget(
        cardsAmount: cardsAmount,
        rotated: true,
      ),
    );
  }
}

class PlayingHandOtherTopWidget extends StatelessWidget {
  const PlayingHandOtherTopWidget({
    super.key,
    required this.cardsAmount,
  });

  final int cardsAmount;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minHeight: 0.0,
      maxHeight: PlayingCardWidget.height,
      alignment: Alignment.bottomCenter,
      child: PlayingHandOtherWidget(
        cardsAmount: cardsAmount,
      ),
    );
  }
}

class PlayingHandOtherWidgetContainer extends StatelessWidget {
  const PlayingHandOtherWidgetContainer({
    super.key,
    this.rotated = false,
    required this.child,
  });

  final Widget child;
  final bool rotated;

  @override
  Widget build(BuildContext context) {
    const value = PlayingCardWidget.width * 0.15;

    return Container(
      color: Colors.red,
      height: !rotated ? value : null,
      width: rotated ? value : null,
      child: child,
    );
  }
}
