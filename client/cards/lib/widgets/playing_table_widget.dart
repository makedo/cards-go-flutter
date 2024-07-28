import 'package:cards/models/playing_card.dart';
import 'package:cards/widgets/playing_card_back_widget.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PlayingTableWidget extends StatelessWidget {
  final PlayingCard trumpCard;
  final List<List<PlayingCard>> tableCards;

  const PlayingTableWidget({
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
            children: tableCards.map((cards) => _CardStack(cards)).toList(),
          ),
        ),
      ),
    ]);
  }
}

class _CardStack extends StatelessWidget {
  static const _leftOffset = 18.0;

  static const _topOffset = 5.0;

  final List<PlayingCard> cards;

  const _CardStack(this.cards);

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
