enum Suit { spades, hearts, diamonds, clubs }

const standardSuites = [
  Suit.spades,
  Suit.hearts,
  Suit.diamonds,
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
        return 'Unknown';
    }
  }
}
