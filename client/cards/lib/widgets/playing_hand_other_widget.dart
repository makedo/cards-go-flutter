import 'package:cards/games/duren/models/duren_state.dart';
import 'package:cards/widgets/playing_card_back_widget.dart';
import 'package:cards/widgets/playing_card_fan_widget.dart';
import 'package:flutter/material.dart';

class PlayingHandOtherWidget extends StatelessWidget {
  final Player? player;
  final bool rotated;

  const PlayingHandOtherWidget({
    super.key,
    required this.player,
    this.rotated = false,
  });

  @override
  Widget build(BuildContext context) {
    int cardsAmount = player?.hand ?? 0;
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
