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
