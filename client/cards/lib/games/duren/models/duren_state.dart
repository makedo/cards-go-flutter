import 'package:cards/models/playing_card.dart';
import 'package:json_annotation/json_annotation.dart';

part 'duren_state.g.dart';

@JsonSerializable(explicitToJson: true)
class DurenState {
  final DurenTable table;
  final Me my;
  final Players players;

  DurenState({
    required this.table,
    required this.my,
    required this.players,
  });

  factory DurenState.fromJson(Map<String, dynamic> json) =>
      _$DurenStateFromJson(json);

  Map<String, dynamic> toJson() => _$DurenStateToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DurenTable {
  final int deck;
  final PlayingCard trump;
  final List<List<PlayingCard>> cards;

  DurenTable({
    required this.deck,
    required this.trump,
    required this.cards,
  });

  factory DurenTable.fromJson(Map<String, dynamic> json) =>
      _$DurenTableFromJson(json);

  Map<String, dynamic> toJson() => _$DurenTableToJson(this);

  void add(PlayingCard card, int? index) {
    if (cards.isEmpty || cards.last.length >= 2) {
      cards.add([]);
    }

    cards[index ?? cards.length - 1].add(card);
  }
}

@JsonSerializable(explicitToJson: true)
class Player {
  final int hand;
  final Role role;

  Player({
    required this.hand,
    required this.role,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Players {
  final Player? left;
  final Player? top;
  final Player? right;

  Players({
    required this.left,
    required this.top,
    required this.right,
  });

  int get topPlayerCards => top?.hand ?? 0;
  int get leftPlayerCards => left?.hand ?? 0;
  int get rightPlayerCards => right?.hand ?? 0;

  Role get topPlayerRole => top?.role ?? Role.idle;
  Role get leftPlayerRole => left?.role ?? Role.idle;
  Role get rightPlayerRole => right?.role ?? Role.idle;

  factory Players.fromJson(Map<String, dynamic> json) =>
      _$PlayersFromJson(json);

  Map<String, dynamic> toJson() => _$PlayersToJson(this);
}

enum Role {
  defender,
  attacker,
  idle,
}

@JsonSerializable(explicitToJson: true)
class Hand {
  final List<PlayingCard> cards;

  Hand({
    required this.cards,
  });

  void remove(PlayingCard card) {
    cards.remove(card);
  }

  factory Hand.fromJson(Map<String, dynamic> json) => _$HandFromJson(json);

  Map<String, dynamic> toJson() => _$HandToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Me {
  final String id;
  final Hand hand;
  final Role role;
  final bool canConfirm;
  final bool canTake;

  Me({
    required this.id,
    required this.hand,
    required this.role,
    required this.canConfirm,
    required this.canTake,
  });

  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);

  Map<String, dynamic> toJson() => _$MeToJson(this);
}
