// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'duren_actions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DurenActionMove _$DurenActionMoveFromJson(Map<String, dynamic> json) =>
    DurenActionMove(
      cardId: json['cardId'] as int,
      playerId: json['playerId'] as String,
      tableIndex: json['tableIndex'] as int?,
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
