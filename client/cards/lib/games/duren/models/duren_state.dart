import 'package:cards/models/playing_card.dart';
import 'package:json_annotation/json_annotation.dart';

part 'duren_state.g.dart';

enum GameState {
  waiting,
  playing,
  finished,
}

@JsonSerializable(explicitToJson: true)
class DurenState {
  final DurenTable? table;
  final Me my;
  final List<Player> players;
  final GameState state;

  DurenState({
    required this.table,
    required this.my,
    required this.players,
    required this.state,
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
  final PlayerState state;

  Player({
    required this.hand,
    required this.role,
    required this.state,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}

enum Role {
  defender,
  attacker,
  idle,
}

extension RoleExtension on Role {
  String get name {
    switch (this) {
      case Role.defender:
        return 'defender';
      case Role.attacker:
        return 'attacker';
      case Role.idle:
        return 'idle';
      default:
        return 'unknown';
    }
  }
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

enum PlayerState {
  waiting,
  ready,
}

@JsonSerializable(explicitToJson: true)
class Me {
  final String id;
  final Hand? hand;
  final Role role;
  final bool canConfirm;
  final PlayerState state;

  Me({
    required this.id,
    required this.hand,
    required this.role,
    required this.canConfirm,
    required this.state,
  });

  factory Me.fromJson(Map<String, dynamic> json) => _$MeFromJson(json);

  Map<String, dynamic> toJson() => _$MeToJson(this);
}
