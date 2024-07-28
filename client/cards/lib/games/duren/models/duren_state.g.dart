// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duren_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DurenState _$DurenStateFromJson(Map<String, dynamic> json) => DurenState(
      table: json['table'] == null
          ? null
          : DurenTable.fromJson(json['table'] as Map<String, dynamic>),
      my: Me.fromJson(json['my'] as Map<String, dynamic>),
      players: Players.fromJson(json['players'] as Map<String, dynamic>),
      state: $enumDecode(_$GameStateEnumMap, json['state']),
    );

Map<String, dynamic> _$DurenStateToJson(DurenState instance) =>
    <String, dynamic>{
      'table': instance.table?.toJson(),
      'my': instance.my.toJson(),
      'players': instance.players.toJson(),
      'state': _$GameStateEnumMap[instance.state]!,
    };

const _$GameStateEnumMap = {
  GameState.waiting: 'waiting',
  GameState.playing: 'playing',
};

DurenTable _$DurenTableFromJson(Map<String, dynamic> json) => DurenTable(
      deck: json['deck'] as int,
      trump: PlayingCard.fromJson(json['trump'] as Map<String, dynamic>),
      cards: (json['cards'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => PlayingCard.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$DurenTableToJson(DurenTable instance) =>
    <String, dynamic>{
      'deck': instance.deck,
      'trump': instance.trump.toJson(),
      'cards':
          instance.cards.map((e) => e.map((e) => e.toJson()).toList()).toList(),
    };

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      hand: json['hand'] as int,
      role: $enumDecode(_$RoleEnumMap, json['role']),
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'hand': instance.hand,
      'role': _$RoleEnumMap[instance.role]!,
    };

const _$RoleEnumMap = {
  Role.defender: 'defender',
  Role.attacker: 'attacker',
  Role.idle: 'idle',
};

Players _$PlayersFromJson(Map<String, dynamic> json) => Players(
      left: json['left'] == null
          ? null
          : Player.fromJson(json['left'] as Map<String, dynamic>),
      top: json['top'] == null
          ? null
          : Player.fromJson(json['top'] as Map<String, dynamic>),
      right: json['right'] == null
          ? null
          : Player.fromJson(json['right'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayersToJson(Players instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('left', instance.left?.toJson());
  writeNotNull('top', instance.top?.toJson());
  writeNotNull('right', instance.right?.toJson());
  return val;
}

Hand _$HandFromJson(Map<String, dynamic> json) => Hand(
      cards: (json['cards'] as List<dynamic>)
          .map((e) => PlayingCard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HandToJson(Hand instance) => <String, dynamic>{
      'cards': instance.cards.map((e) => e.toJson()).toList(),
    };

Me _$MeFromJson(Map<String, dynamic> json) => Me(
      id: json['id'] as String,
      hand: json['hand'] == null
          ? null
          : Hand.fromJson(json['hand'] as Map<String, dynamic>),
      role: $enumDecode(_$RoleEnumMap, json['role']),
      canConfirm: json['canConfirm'] as bool,
      canTake: json['canTake'] as bool,
      state: $enumDecode(_$PlayerStateEnumMap, json['state']),
    );

Map<String, dynamic> _$MeToJson(Me instance) => <String, dynamic>{
      'id': instance.id,
      'hand': instance.hand?.toJson(),
      'role': _$RoleEnumMap[instance.role]!,
      'canConfirm': instance.canConfirm,
      'canTake': instance.canTake,
      'state': _$PlayerStateEnumMap[instance.state]!,
    };

const _$PlayerStateEnumMap = {
  PlayerState.waiting: 'waiting',
  PlayerState.playing: 'playing',
  PlayerState.finished: 'finished',
  PlayerState.left: 'left',
};
