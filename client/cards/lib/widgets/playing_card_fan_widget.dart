import 'package:cards/widgets/playing_card_widget.dart';
import 'package:flutter/material.dart';

/// This widget will array the passed in children in a horizontal line.
/// The children will overlap such that the available space is filled
/// and an even space exists between them. Note that if enough horizontal space
/// is provided, the children will not overlap at all.
class PlayingCardFanWidget extends StatelessWidget {
  /// Children of the flat fan. Will be arrayed evenly (and potentially stacked) across the width.
  /// Renders from first to last, so the last child will be on top.
  final List<Widget> children;
  final bool rotated;

  const PlayingCardFanWidget(
      {Key? key, required this.children, this.rotated = false})
      : super(key: key);

  @override
  Widget build(Object context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final totalCardSize = children.length * (PlayingCardWidget.width);

        final totalSpace =
            rotated ? constraints.maxHeight : constraints.maxWidth;

        // Check if the total width of the PlayingCardWidgets is more than the screen width
        if (totalCardSize > totalSpace) {
          return Stack(
            children: List.generate(
              children.length,
              (index) => Align(
                alignment: Alignment(
                  !rotated && children.length > 1
                      ? -1.0 + (index / (children.length - 1)) * 2.0
                      : 0,
                  rotated && children.length > 1
                      ? -1.0 + (index / (children.length - 1)) * 2.0
                      : 0,
                ),
                child: children[index],
              ),
            ),
          );
        } else {
          return rotated
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                );
        }
      },
    );
  }
}
