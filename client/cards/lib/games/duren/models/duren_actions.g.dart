// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duren_actions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DurenActionMove _$DurenActionMoveFromJson(Map<String, dynamic> json) =>
    DurenActionMove(
      cardId: (json['cardId'] as num).toInt(),
      playerId: json['playerId'] as String,
      tableIndex: (json['tableIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DurenActionMoveToJson(DurenActionMove instance) =>
    <String, dynamic>{
      'type': instance.type,
      'cardId': instance.cardId,
      'playerId': instance.playerId,
      'tableIndex': instance.tableIndex,
    };

DurenActionTake _$DurenActionTakeFromJson(Map<String, dynamic> json) =>
    DurenActionTake(
      playerId: json['playerId'] as String,
    );

Map<String, dynamic> _$DurenActionTakeToJson(DurenActionTake instance) =>
    <String, dynamic>{
      'type': instance.type,
      'playerId': instance.playerId,
    };

DurenActionConfirm _$DurenActionConfirmFromJson(Map<String, dynamic> json) =>
    DurenActionConfirm(
      playerId: json['playerId'] as String,
    );

Map<String, dynamic> _$DurenActionConfirmToJson(DurenActionConfirm instance) =>
    <String, dynamic>{
      'type': instance.type,
      'playerId': instance.playerId,
    };

DurenActionReady _$DurenActionReadyFromJson(Map<String, dynamic> json) =>
    DurenActionReady(
      playerId: json['playerId'] as String,
    );

Map<String, dynamic> _$DurenActionReadyToJson(DurenActionReady instance) =>
    <String, dynamic>{
      'type': instance.type,
      'playerId': instance.playerId,
    };

DurenActionJoin _$DurenActionJoinFromJson(Map<String, dynamic> json) =>
    DurenActionJoin(
      playerId: json['playerId'] as String,
    );

Map<String, dynamic> _$DurenActionJoinToJson(DurenActionJoin instance) =>
    <String, dynamic>{
      'type': instance.type,
      'playerId': instance.playerId,
    };
