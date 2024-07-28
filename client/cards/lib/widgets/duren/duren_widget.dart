import 'package:cards/widgets/playing_card_back_widget.dart';
import 'package:cards/widgets/playing_card_widget.dart';
import 'package:cards/widgets/playing_hand_other_widget.dart';
import 'package:cards/widgets/playing_hand_widget.dart';
import 'package:cards/widgets/playing_table_widget.dart';
import 'package:flutter/material.dart';

class DurenWidget extends StatelessWidget {
  const DurenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          color: Colors.grey,
          height: PlayingCardWidget.width * 0.15,
          child: const OverflowBox(
            minHeight: 0.0,
            maxHeight: PlayingCardWidget.height,
            alignment: Alignment.bottomCenter,
            child: PlayingHandOtherWidget(
              cardsAmount: 6,
            ),
          )),
      Expanded(
        child: Row(
          children: [
            Container(
              color: Colors.grey,
              width: PlayingCardWidget.width * 0.15,
              child: const OverflowBox(
                minWidth: 0.0,
                maxWidth: PlayingCardWidget.width,
                alignment: Alignment.topRight,
                child: PlayingHandOtherWidget(
                  cardsAmount: 6,
                  rotated: true,
                ),
              ),
            ),
            const Expanded(
                child: Column(
              children: [
                // PlayingCardBackWidget(rotated: false),
                Expanded(child: PlayingTableWidget()),
              ],
            )),
            Container(
              color: Colors.grey,
              width: PlayingCardWidget.width * 0.15,
              child: const OverflowBox(
                minWidth: 0.0,
                maxWidth: PlayingCardWidget.width,
                alignment: Alignment.topLeft,
                child: PlayingHandOtherWidget(
                  cardsAmount: 6,
                  rotated: true,
                ),
              ),
            ),
          ],
        ),
      ),
      const PlayingHandWidget(),
    ]);
  }
}
