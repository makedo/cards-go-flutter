// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playing_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayingCard _$PlayingCardFromJson(Map<String, dynamic> json) => PlayingCard(
      id: (json['id'] as num).toInt(),
      suit: $enumDecode(_$SuitEnumMap, json['suit']),
      rank: const RankConverter().fromJson((json['rank'] as num).toInt()),
    );

Map<String, dynamic> _$PlayingCardToJson(PlayingCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'suit': _$SuitEnumMap[instance.suit]!,
      'rank': const RankConverter().toJson(instance.rank),
    };

const _$SuitEnumMap = {
  Suit.spades: 'spades',
  Suit.hearts: 'hearts',
  Suit.diamonds: 'diamonds',
  Suit.clubs: 'clubs',
};
