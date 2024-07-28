import 'package:cards/models/playing_card.dart';
import 'package:cards/widgets/playing_card_fan_widget.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class PlayingHandWidget extends StatelessWidget {
  final List<PlayingCard> cards;

  const PlayingHandWidget({super.key, this.cards = const []});

  @override
  Widget build(BuildContext context) {
    final cardWidgets =
        cards.map((PlayingCard card) => PlayingCardWidget(card: card)).toList();

    return Container(
      color: Colors.grey,
      child: PlayingCardFanWidget(children: cardWidgets),
    );
  }
}
