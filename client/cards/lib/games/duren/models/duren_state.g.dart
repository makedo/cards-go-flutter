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
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      state: $enumDecode(_$GameStateEnumMap, json['state']),
    );

Map<String, dynamic> _$DurenStateToJson(DurenState instance) =>
    <String, dynamic>{
      'table': instance.table?.toJson(),
      'my': instance.my.toJson(),
      'players': instance.players.map((e) => e.toJson()).toList(),
      'state': _$GameStateEnumMap[instance.state]!,
    };

const _$GameStateEnumMap = {
  GameState.waiting: 'waiting',
  GameState.playing: 'playing',
  GameState.finished: 'finished',
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
      state: $enumDecode(_$PlayerStateEnumMap, json['state']),
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'hand': instance.hand,
      'role': _$RoleEnumMap[instance.role]!,
      'state': _$PlayerStateEnumMap[instance.state]!,
    };

const _$RoleEnumMap = {
  Role.defender: 'defender',
  Role.attacker: 'attacker',
  Role.idle: 'idle',
};

const _$PlayerStateEnumMap = {
  PlayerState.waiting: 'waiting',
  PlayerState.ready: 'ready',
};

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
      state: $enumDecode(_$PlayerStateEnumMap, json['state']),
      canMove: json['canMove'] as bool,
    );

Map<String, dynamic> _$MeToJson(Me instance) => <String, dynamic>{
      'id': instance.id,
      'hand': instance.hand?.toJson(),
      'role': _$RoleEnumMap[instance.role]!,
      'canConfirm': instance.canConfirm,
      'state': _$PlayerStateEnumMap[instance.state]!,
      'canMove': instance.canMove,
    };
