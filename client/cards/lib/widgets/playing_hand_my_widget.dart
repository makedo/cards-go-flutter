import 'package:cards/models/playing_card.dart';
import 'package:cards/models/playing_card/suit.dart';
import 'package:cards/widgets/playing_card_widget_draggable.dart';
import 'package:cards/widgets/playing_card_fan_widget.dart';
import 'package:flutter/material.dart';

class PlayingHandMyWidget extends StatelessWidget {
  final List<PlayingCard> cards;
  final Suit trumpSuit;

  const PlayingHandMyWidget({
    super.key,
    required this.trumpSuit,
    this.cards = const [],
  });

  @override
  Widget build(BuildContext context) {
    //sort cards by suite and rank ascending
    //trump suit should be last
    cards.sort((PlayingCard a, PlayingCard b) {
      if (a.suit.index == b.suit.index) {
        return a.rank.value > b.rank.value ? 1 : -1;
      }

      if (a.suit == trumpSuit) {
        return 1;
      }
      if (b.suit == trumpSuit) {
        return -1;
      }

      return a.suit.index > b.suit.index ? 1 : -1;
    });

    final cardWidgets = cards
        .map((PlayingCard card) => PlayingCardWidgetDraggable(card: card))
        .toList();

    return PlayingCardFanWidget(children: cardWidgets);
  }
}
