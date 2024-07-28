import 'package:cards/widgets/playing_card_back_widget.dart';
import 'package:cards/widgets/playing_card_fan_widget.dart';
import 'package:flutter/material.dart';

class PlayingHandOtherWidget extends StatelessWidget {
  final int cardsAmount;
  final bool rotated;

  const PlayingHandOtherWidget({
    super.key,
    required this.cardsAmount,
    this.rotated = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidgets = <PlayingCardBackWidget>[];
    for (var i = 0; i < cardsAmount; i++) {
      cardWidgets.add(PlayingCardBackWidget(rotated: rotated));
    }

    return PlayingCardFanWidget(
      rotated: rotated,
      children: cardWidgets,
    );
  }
}
