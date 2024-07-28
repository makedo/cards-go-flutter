import 'package:cards/models/playing_card.dart';
import 'package:cards/models/playing_card/rank.dart';
import 'package:cards/models/playing_card/suit.dart';
import 'package:cards/widgets/playing_card_back_widget.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class PlayingTableWidget extends StatelessWidget {
  const PlayingTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final trumpCard = PlayingCard(
      suit: Suit.hearts,
      rank: Rank.ace,
    );

    final tableCards = [
      PlayingCard(suit: Suit.spades, rank: Rank.ace),
      PlayingCard(suit: Suit.hearts, rank: Rank.two),
      PlayingCard(suit: Suit.diamonds, rank: Rank.three),
      PlayingCard(suit: Suit.clubs, rank: Rank.four),
      PlayingCard(suit: Suit.spades, rank: Rank.five),
      PlayingCard(suit: Suit.hearts, rank: Rank.ten),
    ];

    return Column(children: [
      Stack(
        alignment: Alignment.topCenter,
        children: [
          PlayingCardWidget(card: trumpCard),
          const PlayingCardBackWidget(rotated: true),
        ],
      ),
      Expanded(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.amber,
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: tableCards
                .map((card) => PlayingCardWidget(card: card))
                .toList(),
          ),
        ),
      ),
    ]);
  }
}
