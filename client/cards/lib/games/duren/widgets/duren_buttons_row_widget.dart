import 'package:cards/games/duren/models/duren_state.dart';
import 'package:flutter/material.dart';

class DurenActionsRowWidget extends StatelessWidget {
  final DurenState durenState;
  final VoidCallback onTake;
  final VoidCallback onConfirm;
  final VoidCallback onReady;

  const DurenActionsRowWidget({
    super.key,
    required this.durenState,
    required this.onTake,
    required this.onConfirm,
    required this.onReady,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    var my = durenState.my;
    children.add(Text(
      my.role.name,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 10.0,
      ),
    ));

    if (my.canConfirm && my.role == Role.attacker) {
      children.add(ElevatedButton(
        onPressed: onConfirm,
        child: const Text('Confirm'),
      ));
    }

    if (my.canConfirm && my.role == Role.defender) {
      children.add(ElevatedButton(
        onPressed: onTake,
        child: const Text('Take'),
      ));
    }

    if (my.state == PlayerState.waiting &&
        durenState.state == GameState.waiting) {
      children.add(ElevatedButton(
        onPressed: onReady,
        child: const Text('Ready'),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
