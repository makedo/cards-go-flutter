import 'package:cards/models/duren/duren_state.dart';
import 'package:cards/models/playing_card.dart';
import 'package:cards/models/playing_card/rank.dart';
import 'package:cards/models/playing_card/suit.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:cards/widgets/playing_hand_other_widget.dart';
import 'package:cards/widgets/playing_hand_my_widget.dart';
import 'package:cards/widgets/duren/duren_table_widget.dart';
import 'package:flutter/material.dart';

class DurenWidget extends StatefulWidget {
  const DurenWidget({super.key});

  @override
  State<DurenWidget> createState() => _DurenWidgetState();
}

class _DurenWidgetState extends State<DurenWidget> {
  DurenState durenState = DurenState(
    my: Me(
      hand: Hand(cards: [
        PlayingCard(suit: Suit.spades, rank: Rank.ace),
        PlayingCard(suit: Suit.hearts, rank: Rank.two),
        PlayingCard(suit: Suit.diamonds, rank: Rank.three),
        PlayingCard(suit: Suit.clubs, rank: Rank.four),
        PlayingCard(suit: Suit.spades, rank: Rank.five),
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.hearts, rank: Rank.ten),
        PlayingCard(suit: Suit.hearts, rank: Rank.ten),
        PlayingCard(suit: Suit.hearts, rank: Rank.ten),
        PlayingCard(suit: Suit.hearts, rank: Rank.ten),
        PlayingCard(suit: Suit.hearts, rank: Rank.king),
      ]),
      role: Role.attacker,
    ),
    players: Players(
      left: Player(
        cards: 6,
        role: Role.defender,
      ),
      top: null,
      right: Player(
        cards: 0,
        role: Role.idle,
      ),
    ),
    table: DurenTable(
      deck: 2,
      trump: PlayingCard(
        suit: Suit.hearts,
        rank: Rank.ace,
      ),
      cards: [
        // [
        //   PlayingCard(suit: Suit.spades, rank: Rank.six),
        //   PlayingCard(suit: Suit.spades, rank: Rank.ace),
        // ],
        // [
        //   PlayingCard(suit: Suit.diamonds, rank: Rank.seven),
        //   PlayingCard(suit: Suit.diamonds, rank: Rank.king),
        // ],
        // [
        //   PlayingCard(suit: Suit.clubs, rank: Rank.eight),
        //   PlayingCard(suit: Suit.clubs, rank: Rank.queen),
        // ],
        [
          PlayingCard(suit: Suit.hearts, rank: Rank.nine),
          // PlayingCard(suit: Suit.hearts, rank: Rank.jack),
        ],
        [
          PlayingCard(suit: Suit.spades, rank: Rank.ten),
          // PlayingCard(suit: Suit.hearts, rank: Rank.ten),
        ],
        [
          PlayingCard(suit: Suit.spades, rank: Rank.jack),
        ],
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
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
                    onDragAccept: _onDragAccept,
                  ),
                  onWillAccept: _onDragWillAccept,
                  onLeave: _onDragLeave,
                  onAccept: (PlayingCard card) => _onDragAccept(card, null),
                ),
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
  }

  void _onDragAccept(PlayingCard card, int? index) {
    durenState.my.hand.remove(card);
    durenState.table.add(card, index);
    setState(() => durenState = durenState);
  }

  void _onDragLeave(PlayingCard? card) {}

  bool _onDragWillAccept(PlayingCard? card) {
    if (card == null) return false;
    return true;
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
