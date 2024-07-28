import 'package:cards/models/playing_card.dart';
import 'package:cards/models/playing_card/suit.dart';
import 'package:flutter/material.dart';

class PlayingCardWidget extends StatelessWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static const double width = 57.1 * 1.5;

  static const double height = 88.9 * 1.5;

  final PlayingCard card;

  const PlayingCardWidget({super.key, required this.card});

  get color {
    if (card.suit == Suit.hearts || card.suit == Suit.diamonds) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
            width: width,
            height: height,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                    color: Colors.black,
                    width: 1), // Adjust the color and width as needed
                borderRadius: BorderRadius.circular(
                    10), // Adjust the border radius as needed
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    card.rank.toString(),
                    style: TextStyle(color: color),
                  ),
                  Text(card.suit.symbol(), style: TextStyle(color: color)),
                ],
              ),
            )));
  }
}
