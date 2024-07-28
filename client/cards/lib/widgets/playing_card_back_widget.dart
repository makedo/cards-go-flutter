import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class PlayingCardBackWidget extends StatelessWidget {
  final bool rotated;
  final int? amount;

  const PlayingCardBackWidget({super.key, this.rotated = false, this.amount});

  @override
  Widget build(BuildContext context) {
    const width = PlayingCardWidget.width;
    const height = PlayingCardWidget.height;

    var amountWidget = amount != null
        ? Center(
            child: Text(
              amount.toString(),
            ),
          )
        : null;
    return SizedBox(
        width: rotated ? height : width,
        height: rotated ? width : height,
        child: Card(
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
                color: Colors.black,
                width: 1), // Adjust the color and width as needed
            borderRadius:
                BorderRadius.circular(4), // Adjust the border radius as needed
          ),
          child: amountWidget,
        ));
  }
}
