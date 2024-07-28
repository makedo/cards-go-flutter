import 'package:cards/games/duren/models/duren_actions.dart';
import 'package:cards/games/duren/models/duren_state.dart';
import 'package:cards/games/duren/widgets/duren_buttons_row_widget.dart';
import 'package:cards/games/duren/widgets/duren_table_widget.dart';
import 'package:cards/models/playing_card.dart';
import 'package:cards/services/player_service.dart';
import 'package:cards/services/websocket_service.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:cards/widgets/playing_hand_other_widget.dart';
import 'package:cards/widgets/playing_hand_my_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DurenGameWidget extends StatefulWidget {
  const DurenGameWidget({super.key});

  @override
  State<DurenGameWidget> createState() => _DurenGameWidgetState();
}

class _DurenGameWidgetState extends State<DurenGameWidget> {
  final websocketService = WebsocketService();
  late Future<void> setupFuture;

  Future<void> setup() async {
    var durenStateNotifier =
        Provider.of<DurenStateNotifier>(context, listen: false);
    var playerService = Provider.of<PlayerService>(context, listen: false);

    var playerId = await playerService.getPlayerId();
    await websocketService.connect(playerId);

    websocketService.listen(durenStateNotifier.updateFromWebSocket);
  }

  @override
  void initState() {
    super.initState();
    setupFuture = setup();
  }

  @override
  Widget build(BuildContext context) {
    renderMyHandWidget(DurenState durenState) =>
        durenState.state == GameState.playing &&
                durenState.table?.trump != null &&
                durenState.my.hand != null
            ? PlayingHandMyWidget(
                trumpSuit: durenState.table!.trump.suit,
                cards: durenState.my.hand!.cards,
              )
            : Container();

    renderDurenTableWidget(DurenStateNotifier durenStateNotifier) =>
        durenStateNotifier.durenState!.state == GameState.playing &&
                durenStateNotifier.durenState!.table != null
            ? DragTarget<PlayingCard>(
                builder: (context, candidateData, rejectedData) =>
                    DurenTableWidget(
                  table: durenStateNotifier.durenState!.table!,
                  onDragWillAccept: _onDragWillAccept,
                  onDragLeave: _onDragLeave,
                  onDragAccept: _onDragAccept(durenStateNotifier),
                ),
                onWillAcceptWithDetails: _onDragWillAccept,
                onLeave: _onDragLeave,
                onAcceptWithDetails: (DragTargetDetails<PlayingCard> details) =>
                    _onDragAccept(durenStateNotifier)(details.data, null),
              )
            : const Column(
                children: [Text('Waiting for starting a game....')],
              );
    return FutureBuilder<void>(
      future: setupFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderWidget();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Now that you have the player ID and the WebSocket is connected, you can start listening
          return Consumer<DurenStateNotifier>(
            builder: (context, durenStateNotifier, child) {
              var durenState = durenStateNotifier.durenState;

              if (durenState == null) {
                return const LoaderWidget();
              }

              Player? topPlayer;
              Player? rightPlayer;
              Player? leftPlayer;
              switch (durenState.players.length) {
                case 1:
                  topPlayer = durenState.players[0];
                  break;
                case 2:
                  topPlayer = durenState.players[0];
                  rightPlayer = durenState.players[1];
                  break;
                case 3:
                  leftPlayer = durenState.players[0];
                  topPlayer = durenState.players[1];
                  rightPlayer = durenState.players[2];
                  break;
              }

              return Column(
                children: [
                  PlayingHandOtherWidgetContainer(
                    rotated: false,
                    child: PlayingHandOtherTopWidget(
                      player: topPlayer,
                    ),
                  ),
                  topPlayer != null
                      ? Text(topPlayer.role.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                          ))
                      : Container(),
                  Expanded(
                    child: Row(
                      children: [
                        PlayingHandOtherWidgetContainer(
                          rotated: true,
                          child: PlayingHandOtherLeftWidget(
                            player: leftPlayer,
                          ),
                        ),
                        leftPlayer != null
                            ? Text(leftPlayer.role.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                ))
                            : Container(),
                        Expanded(
                          child: renderDurenTableWidget(durenStateNotifier),
                        ),
                        PlayingHandOtherWidgetContainer(
                          rotated: true,
                          child: PlayingHandOtherRightWidget(
                            player: rightPlayer,
                          ),
                        ),
                        rightPlayer != null
                            ? Text(rightPlayer.role.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                ))
                            : Container()
                      ],
                    ),
                  ),
                  DurenActionsRowWidget(
                    durenState: durenState,
                    onTake: () => _onTake(durenState),
                    onConfirm: () => _onConfirm(durenState),
                    onReady: () => _onReady(durenState),
                  ),
                  Container(
                    color: Colors.grey,
                    child: renderMyHandWidget(durenState),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  void _onTake(DurenState durenState) {
    websocketService.send(DurenActionTake(
      playerId: durenState.my.id,
    ));
  }

  void _onConfirm(DurenState durenState) {
    websocketService.send(DurenActionConfirm(
      playerId: durenState.my.id,
    ));
  }

  void _onReady(DurenState durenState) {
    websocketService.send(DurenActionReady(
      playerId: durenState.my.id,
    ));
  }

  Function _onDragAccept(DurenStateNotifier durenStateNotifier) {
    return (PlayingCard card, int? index) {
      if (durenStateNotifier.durenState!.my.canMove == false) {
        return;
      }
      //move the card in the local state for smooth experience
      durenStateNotifier.move(card, index);

      // Convert the message to a JSON string
      websocketService.send(DurenActionMove(
        cardId: card.id,
        playerId: durenStateNotifier.durenState!.my.id,
        tableIndex: index,
      ));
    };
  }

  void _onDragLeave(PlayingCard? card) {}

  bool _onDragWillAccept(DragTargetDetails<PlayingCard> details) {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    websocketService.disconnect();
  }
}

class PlayingHandOtherRightWidget extends StatelessWidget {
  const PlayingHandOtherRightWidget({
    super.key,
    required this.player,
  });

  final Player? player;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minWidth: 0.0,
      maxWidth: PlayingCardWidget.width,
      alignment: Alignment.topLeft,
      child: PlayingHandOtherWidget(
        player: player,
        rotated: true,
      ),
    );
  }
}

class PlayingHandOtherLeftWidget extends StatelessWidget {
  const PlayingHandOtherLeftWidget({
    super.key,
    required this.player,
  });

  final Player? player;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minWidth: 0.0,
      maxWidth: PlayingCardWidget.width,
      alignment: Alignment.topRight,
      child: PlayingHandOtherWidget(
        player: player,
        rotated: true,
      ),
    );
  }
}

class PlayingHandOtherTopWidget extends StatelessWidget {
  const PlayingHandOtherTopWidget({
    super.key,
    required this.player,
  });

  final Player? player;

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minHeight: 0.0,
      maxHeight: PlayingCardWidget.height,
      alignment: Alignment.bottomCenter,
      child: PlayingHandOtherWidget(
        player: player,
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

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
