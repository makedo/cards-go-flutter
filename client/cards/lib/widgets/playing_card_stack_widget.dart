import 'dart:math';

import 'package:cards/models/playing_card.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class PlayingCardStackWidget extends StatelessWidget {
  static const _leftOffset = 18.0;

  static const _topOffset = 5.0;

  final List<PlayingCard> cards;

  const PlayingCardStackWidget({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: PlayingCardWidget.width + _leftOffset,
      height: PlayingCardWidget.height + _topOffset * 5,
      child: Stack(
        children: [
          for (var i = max(0, cards.length - 6); i < cards.length; i++)
            Positioned(
              top: i * _topOffset,
              left: i * _leftOffset,
              child: PlayingCardWidget(card: cards[i]),
            ),
        ],
      ),
    );
  }
}
