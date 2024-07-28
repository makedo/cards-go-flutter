import 'package:cards/games/duren/models/duren_state.dart';
import 'package:cards/models/playing_card.dart';
import 'package:cards/games/duren/widgets/duren_table_trump_deck_widget.dart';
import 'package:cards/widgets/playing_card_stack_widget.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class DurenTableWidget extends StatelessWidget {
  final DurenTable table;
  final Function onDragWillAccept;
  final Function onDragLeave;
  final Function onDragAccept;

  const DurenTableWidget({
    super.key,
    required this.table,
    required this.onDragWillAccept,
    required this.onDragLeave,
    required this.onDragAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DurenTableTrumpDeckWidget(table: table),
      Expanded(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.amber,
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: table.cards
                .asMap()
                .map((index, cards) =>
                    MapEntry(index, _buildCardStack(cards, index)))
                .values
                .toList(),
          ),
        ),
      ),
    ]);
  }

  Widget _buildCardStack(List<PlayingCard> cards, int index) {
    if (cards.length == 1) {
      return DragTarget<PlayingCard>(
        builder: (context, candidateData, rejectedData) => Opacity(
          opacity: candidateData.isNotEmpty ? 0.5 : 1.0,
          child: PlayingCardWidget(card: cards.first),
        ),
        onWillAccept: (PlayingCard? card) => onDragWillAccept(card),
        onLeave: (PlayingCard? card) => onDragLeave(card),
        onAccept: (PlayingCard card) => onDragAccept(card, index),
      );
    }

    return PlayingCardStackWidget(cards: cards);
  }
}
