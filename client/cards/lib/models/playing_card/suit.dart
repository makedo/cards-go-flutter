import 'package:flutter/material.dart';

enum Suit { spades, hearts, diamonds, clubs }

const standardSuites = [
  Suit.hearts,
  Suit.diamonds,
  Suit.spades,
  Suit.clubs,
];

extension SuitExtension on Suit {
  String symbol() {
    switch (this) {
      case Suit.spades:
        return '\u2660'; // ASCII for spades
      case Suit.hearts:
        return '\u2665'; // ASCII for hearts
      case Suit.diamonds:
        return '\u2666'; // ASCII for diamonds
      case Suit.clubs:
        return '\u2663'; // ASCII for clubs
      default:
        throw Exception("Unknown suit enum: ${toString()}");
    }
  }

  Color color() {
    if (this == Suit.hearts || this == Suit.diamonds) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
