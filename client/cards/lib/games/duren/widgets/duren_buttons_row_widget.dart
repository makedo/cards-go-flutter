import 'package:cards/games/duren/models/duren_state.dart';
import 'package:flutter/material.dart';

class DurenButtonsRowWidget extends StatelessWidget {
  final Me my;
  final VoidCallback onTake;
  final VoidCallback onConfirm;
  final VoidCallback onReady;

  const DurenButtonsRowWidget({
    super.key,
    required this.my,
    required this.onTake,
    required this.onConfirm,
    required this.onReady,
  });

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

    if (my.state == PlayerState.waiting) {
      buttons.add(ElevatedButton(
        onPressed: onReady,
        child: const Text('Ready'),
      ));
    }

    if (my.state == PlayerState.finished) {
      buttons.add(ElevatedButton(
        onPressed: onReady,
        child: const Text('Continue'),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}
