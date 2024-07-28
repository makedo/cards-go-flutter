import 'package:cards/models/duren/duren_state.dart';
import 'package:cards/models/playing_card.dart';
import 'package:cards/models/playing_card/rank.dart';
import 'package:cards/models/playing_card/suit.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:cards/widgets/playing_hand_other_widget.dart';
import 'package:cards/widgets/playing_hand_my_widget.dart';
import 'package:cards/widgets/duren/duren_table_widget.dart';
import 'package:flutter/material.dart';

class DurenWidget extends StatelessWidget {
  const DurenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DurenState(
      my: Me(
        hand: [
          PlayingCard(suit: Suit.spades, rank: Rank.ace),
          PlayingCard(suit: Suit.hearts, rank: Rank.two),
          PlayingCard(suit: Suit.diamonds, rank: Rank.three),
          PlayingCard(suit: Suit.clubs, rank: Rank.four),
          PlayingCard(suit: Suit.spades, rank: Rank.five),
          PlayingCard(suit: Suit.hearts, rank: Rank.six),
        ],
        role: Role.attacker,
      ),
      players: Players(
        left: Player(
          cards: 6,
          role: Role.defender,
        ),
        top: Player(
          cards: 7,
          role: Role.idle,
        ),
        right: Player(
          cards: 8,
          role: Role.idle,
        ),
      ),
      table: DurenTable(
        deck: 9,
        trump: PlayingCard(
          suit: Suit.hearts,
          rank: Rank.ace,
        ),
        cards: [
          [
            PlayingCard(suit: Suit.spades, rank: Rank.six),
            PlayingCard(suit: Suit.spades, rank: Rank.ace),
          ],
          [
            PlayingCard(suit: Suit.diamonds, rank: Rank.seven),
            PlayingCard(suit: Suit.diamonds, rank: Rank.king),
          ],
          [
            PlayingCard(suit: Suit.clubs, rank: Rank.eight),
            PlayingCard(suit: Suit.clubs, rank: Rank.queen),
          ],
          [
            PlayingCard(suit: Suit.hearts, rank: Rank.nine),
            PlayingCard(suit: Suit.hearts, rank: Rank.jack),
          ],
          [
            PlayingCard(suit: Suit.spades, rank: Rank.ten),
            PlayingCard(suit: Suit.hearts, rank: Rank.ten),
          ],
          [
            PlayingCard(suit: Suit.spades, rank: Rank.jack),
          ],
        ],
      ),
    );

    return Column(children: [
      PlayingHandOtherWidgetContainer(
        rotated: false,
        child: PlayingHandOtherTopWidget(
          cardsAmount: state.players.top.cards,
        ),
      ),
      Expanded(
        child: Row(
          children: [
            PlayingHandOtherWidgetContainer(
              rotated: true,
              child: PlayingHandOtherLeftWidget(
                cardsAmount: state.players.left.cards,
              ),
            ),
            Expanded(
              child: DurenTableWidget(
                tableCards: state.table.cards,
                trumpCard: state.table.trump,
              ),
            ),
            PlayingHandOtherWidgetContainer(
              rotated: true,
              child: PlayingHandOtherRightWidget(
                cardsAmount: state.players.right.cards,
              ),
            ),
          ],
        ),
      ),
      Container(
        color: Colors.grey,
        child: PlayingHandMyWidget(
          cards: state.my.hand,
        ),
      ),
    ]);
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
