import 'package:cards/models/playing_card.dart';
import 'package:cards/models/playing_card/rank.dart';
import 'package:cards/models/playing_card/suit.dart';
import 'package:cards/widgets/playing_card_fan_widget.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class PlayingHandWidget extends StatelessWidget {
  const PlayingHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      PlayingCard(suit: Suit.spades, rank: Rank.ace),
      PlayingCard(suit: Suit.hearts, rank: Rank.two),
      PlayingCard(suit: Suit.diamonds, rank: Rank.three),
      PlayingCard(suit: Suit.clubs, rank: Rank.four),
      PlayingCard(suit: Suit.spades, rank: Rank.five),
      PlayingCard(suit: Suit.hearts, rank: Rank.six),
    ];

    final cardWidgets =
        cards.map((PlayingCard card) => PlayingCardWidget(card: card)).toList();

    return Container(
        color: Colors.grey, child: PlayingCardFanWidget(children: cardWidgets));
  }
}
