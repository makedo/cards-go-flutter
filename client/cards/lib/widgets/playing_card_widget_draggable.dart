import 'package:cards/models/playing_card.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class PlayingCardWidgetDraggable extends StatelessWidget {
  final PlayingCard card;

  const PlayingCardWidgetDraggable({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Draggable<PlayingCard>(
      data: card,
      feedback: PlayingCardWidget(card: card),
      childWhenDragging:
          Opacity(opacity: 0.5, child: PlayingCardWidget(card: card)),
      child: PlayingCardWidget(card: card),
    );
  }
}
