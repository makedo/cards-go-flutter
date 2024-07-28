import 'dart:math';

import 'package:cards/models/playing_card.dart';
import 'package:cards/models/playing_card/suit.dart';
import 'package:flutter/material.dart';

class PlayingCardWidget extends StatelessWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static const double width = 57.1 * 1.5;

  static const double height = 88.9 * 1.5;

  final PlayingCard card;

  const PlayingCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final smallCardIdentifier = Padding(
        padding: const EdgeInsets.only(
          top: 3,
          left: 2,
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  card.rank.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: card.suit.color(),
                    height: 0.9,
                  ),
                ),
                Text(
                  card.suit.symbol(),
                  style: TextStyle(
                    fontSize: 15,
                    color: card.suit.color(),
                    height: 0.9,
                  ),
                ),
              ],
            )
          ],
        ));

    final mainCardIdentifier = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          card.rank.toString(),
          style: TextStyle(
            fontSize: 25,
            color: card.suit.color(),
          ),
        ),
        Text(
          card.suit.symbol(),
          style: TextStyle(
            fontSize: 25,
            color: card.suit.color(),
          ),
        ),
      ],
    );

    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.black,
            width: 1,
          ), // Adjust the color and width as needed
          borderRadius: BorderRadius.circular(
            4,
          ), // Adjust the border radius as needed
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            smallCardIdentifier,
            Expanded(child: mainCardIdentifier),
            Transform.rotate(
              angle: pi,
              child: smallCardIdentifier,
            )
          ],
        ),
      ),
    );
  }
}
