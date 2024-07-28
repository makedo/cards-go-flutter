import 'package:cards/models/playing_card.dart';

class DurenState {
  final DurenTable table;
  final Me my;
  final Players players;

  DurenState({
    required this.table,
    required this.my,
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

class Players {
  final Player left;
  final Player top;
  final Player right;

  Players({
    required this.left,
    required this.top,
    required this.right,
  });
}

enum Role {
  defender,
  attacker,
  idle,
}

class Me {
  final List<PlayingCard> hand;
  final Role role;

  Me({
    required this.hand,
    required this.role,
  });
}
