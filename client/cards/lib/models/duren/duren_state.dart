import 'package:cards/models/playing_card.dart';

class DurenState {
  final DurenTable table;
  final Me me;
  final Map<String, Player> players;

  DurenState({
    required this.table,
    required this.me,
    required this.players,
  });
}

class DurenTable {
  final int deck;
  final PlayingCard trump;
  final List<List<PlayingCard>> cards;

  DurenTable({
    required this.deck,
    required this.trump,
    required this.cards,
  });
}

class Player {
  final int cards;
  final Role role;

  Player({
    required this.cards,
    required this.role,
  });
}

enum Role {
  defender,
  attacker,
  idle,
}

class Me {
  final List<PlayingCard> hand;
  final String role;

  Me({
    required this.hand,
    required this.role,
  });
}
