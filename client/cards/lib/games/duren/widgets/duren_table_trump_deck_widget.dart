import 'package:cards/games/duren/models/duren_state.dart';
import 'package:cards/widgets/playing_card_back_widget.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:cards/widgets/suit_widget.dart';
import 'package:flutter/material.dart';

class DurenTableTrumpDeckWidget extends StatelessWidget {
  final DurenTable table;

  const DurenTableTrumpDeckWidget({
    super.key,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (table.deck >= 1) {
      children.add(PlayingCardWidget(card: table.trump));
    }

    if (table.deck > 1) {
      children.add(PlayingCardBackWidget(rotated: true, amount: table.deck));
    }

    if (table.deck == 0) {
      children.add(SuitWidget(suit: table.trump.suit));
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: children,
    );
  }
}
