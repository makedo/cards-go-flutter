import 'package:cards/games/duren/models/duren_state.dart';
import 'package:flutter/material.dart';

class DurenButtonsRowWidget extends StatelessWidget {
  final Me my;
  final VoidCallback onTake;
  final VoidCallback onConfirm;

  const DurenButtonsRowWidget(
      {super.key,
      required this.my,
      required this.onTake,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    var buttons = <ElevatedButton>[];

    if (my.canConfirm) {
      buttons.add(ElevatedButton(
        onPressed: onConfirm,
        child: const Text('Confirm'),
      ));
    }

    if (my.canTake) {
      buttons.add(ElevatedButton(
        onPressed: onTake,
        child: const Text('Take'),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}
