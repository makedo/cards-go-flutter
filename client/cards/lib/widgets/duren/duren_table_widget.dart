import 'package:cards/models/playing_card.dart';
import 'package:cards/widgets/playing_card_back_widget.dart';
import 'package:cards/widgets/playing_card_stack_widget.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DurenTableWidget extends StatelessWidget {
  final PlayingCard trumpCard;
  final List<List<PlayingCard>> tableCards;

  const DurenTableWidget({
    super.key,
    required this.trumpCard,
    this.tableCards = const [[]],
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        alignment: Alignment.topCenter,
        children: [
          PlayingCardWidget(card: trumpCard),
          const PlayingCardBackWidget(rotated: true),
        ],
      ),
      Expanded(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.amber,
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: tableCards
                .map((cards) => PlayingCardStackWidget(cards: cards))
                .toList(),
          ),
        ),
      ),
    ]);
  }
}
