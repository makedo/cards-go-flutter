import 'package:cards/games/duren/models/duren_state.dart';
import 'package:cards/widgets/playing_card_back_widget.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class DurenTableTrumpDeckWidget extends StatelessWidget {
  final DurenTable table;

  const DurenTableTrumpDeckWidget({
    super.key,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    Widget trumpCardWidget = PlayingCardWidget(card: table.trump);
    if (table.deck < 1) {
      trumpCardWidget = Opacity(
        opacity: 0.5,
        child: trumpCardWidget,
      );
    }

    List<Widget> children = [trumpCardWidget];
    if (table.deck > 1) {
      children.add(const PlayingCardBackWidget(rotated: true));
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: children,
    );
  }
}
