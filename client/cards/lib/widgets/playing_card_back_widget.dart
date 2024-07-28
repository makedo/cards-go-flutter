import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

class PlayingCardBackWidget extends StatelessWidget {
  final bool rotated;

  const PlayingCardBackWidget({super.key, this.rotated = false});

  @override
  Widget build(BuildContext context) {
    const width = PlayingCardWidget.width;
    const height = PlayingCardWidget.height;
    return SizedBox(
        width: rotated ? height : width,
        height: rotated ? width : height,
        child: Card(
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Colors.black,
                  width: 1), // Adjust the color and width as needed
              borderRadius: BorderRadius.circular(
                  10), // Adjust the border radius as needed
            )));
  }
}
