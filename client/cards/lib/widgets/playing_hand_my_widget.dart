import 'package:cards/models/playing_card.dart';
import 'package:cards/widgets/playing_card_widget_draggable.dart';
import 'package:cards/widgets/playing_card_fan_widget.dart';
import 'package:flutter/material.dart';

class PlayingHandMyWidget extends StatelessWidget {
  final List<PlayingCard> cards;

  const PlayingHandMyWidget({super.key, this.cards = const []});

  @override
  Widget build(BuildContext context) {
    final cardWidgets = cards
        .map((PlayingCard card) => PlayingCardWidgetDraggable(card: card))
        .toList();

    return PlayingCardFanWidget(children: cardWidgets);
  }
}
