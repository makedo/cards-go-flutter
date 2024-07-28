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

  void add(PlayingCard card, int? index) {
    if (cards.isEmpty || cards.last.length >= 2) {
      cards.add([]);
    }

    cards[index ?? cards.length - 1].add(card);
  }
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
  final Player? left;
  final Player? top;
  final Player? right;

  Players({
    required this.left,
    required this.top,
    required this.right,
  });

  int get topPlayerCards => top?.cards ?? 0;
  int get leftPlayerCards => left?.cards ?? 0;
  int get rightPlayerCards => right?.cards ?? 0;

  Role get topPlayerRole => top?.role ?? Role.idle;
  Role get leftPlayerRole => left?.role ?? Role.idle;
  Role get rightPlayerRole => right?.role ?? Role.idle;
}

enum Role {
  defender,
  attacker,
  idle,
}

class Hand {
  final List<PlayingCard> cards;

  Hand({
    required this.cards,
  });

  void remove(PlayingCard card) {
    cards.remove(card);
  }
}

class Me {
  final Hand hand;
  final Role role;

  Me({
    required this.hand,
    required this.role,
  });
}
