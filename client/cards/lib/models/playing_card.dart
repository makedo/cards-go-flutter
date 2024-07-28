import 'package:cards/models/playing_card/rank.dart';
import 'package:cards/models/playing_card/suit.dart';

class PlayingCard {
  final Suit suit;
  final Rank rank;

  PlayingCard({required this.suit, required this.rank});
}
