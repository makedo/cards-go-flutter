import 'package:cards/models/duren/duren_state.dart';
import 'package:cards/models/playing_card.dart';
import 'package:cards/models/playing_card/rank.dart';
import 'package:cards/models/playing_card/suit.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:cards/widgets/playing_hand_other_widget.dart';
import 'package:cards/widgets/playing_hand_widget.dart';
import 'package:cards/widgets/playing_table_widget.dart';
import 'package:flutter/material.dart';

class DurenWidget extends StatelessWidget {
  const DurenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DurenState(
      me: Me(
        hand: [
          PlayingCard(suit: Suit.spades, rank: Rank.ace),
          PlayingCard(suit: Suit.hearts, rank: Rank.two),
          PlayingCard(suit: Suit.diamonds, rank: Rank.three),
          PlayingCard(suit: Suit.clubs, rank: Rank.four),
          PlayingCard(suit: Suit.spades, rank: Rank.five),
          PlayingCard(suit: Suit.hearts, rank: Rank.six),
        ],
        role: 'attacker',
      ),
      players: {
        'left': Player(
          cards: 6,
          role: Role.defender,
        ),
        'top': Player(
          cards: 7,
          role: Role.idle,
        ),
        'right': Player(
          cards: 8,
          role: Role.idle,
        ),
      },
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
      Container(
        color: Colors.red,
        height: PlayingCardWidget.width * 0.15,
        child: OverflowBox(
          minHeight: 0.0,
          maxHeight: PlayingCardWidget.height,
          alignment: Alignment.bottomCenter,
          child: PlayingHandOtherWidget(
            cardsAmount: state.players['top']!.cards,
          ),
        ),
      ),
      Expanded(
        child: Row(
          children: [
            Container(
              color: Colors.red,
              width: PlayingCardWidget.width * 0.15,
              child: OverflowBox(
                minWidth: 0.0,
                maxWidth: PlayingCardWidget.width,
                alignment: Alignment.topRight,
                child: PlayingHandOtherWidget(
                  cardsAmount: state.players['left']!.cards,
                  rotated: true,
                ),
              ),
            ),
            Expanded(
              child: PlayingTableWidget(
                tableCards: state.table.cards,
                trumpCard: state.table.trump,
              ),
            ),
            Container(
              color: Colors.red,
              width: PlayingCardWidget.width * 0.15,
              child: OverflowBox(
                minWidth: 0.0,
                maxWidth: PlayingCardWidget.width,
                alignment: Alignment.topLeft,
                child: PlayingHandOtherWidget(
                  cardsAmount: state.players['right']!.cards,
                  rotated: true,
                ),
              ),
            ),
          ],
        ),
      ),
      PlayingHandWidget(
        cards: state.me.hand,
      ),
    ]);
  }
}
