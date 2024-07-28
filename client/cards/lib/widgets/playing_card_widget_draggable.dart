import 'package:cards/models/playing_card.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class PlayingCardWidgetDraggable extends StatelessWidget {
  final PlayingCard card;

  const PlayingCardWidgetDraggable({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final playingCardWidget = PlayingCardWidget(card: card);
    return Draggable<PlayingCard>(
        data: card,
        feedback: Transform.rotate(
          angle: -0.1,
          child: playingCardWidget,
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: playingCardWidget,
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: playingCardWidget,
        ));
  }
}
