import 'package:cards/models/playing_card/suit.dart';
import 'package:flutter/material.dart';

class SuitWidget extends StatelessWidget {
  final Suit suit;

  const SuitWidget({
    super.key,
    required this.suit,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      suit.symbol(),
      style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: 50,
        color: suit.color(),
      ),
    );
  }
}
