import 'package:cards/models/playing_card/rank.dart';
import 'package:cards/models/playing_card/suit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'playing_card.g.dart';

@JsonSerializable(explicitToJson: true)
class PlayingCard {
  final int id;
  final Suit suit;

  @RankConverter()
  final Rank rank;

  PlayingCard({required this.id, required this.suit, required this.rank});

  factory PlayingCard.fromJson(Map<String, dynamic> json) =>
      _$PlayingCardFromJson(json);

  Map<String, dynamic> toJson() => _$PlayingCardToJson(this);
}

class RankConverter implements JsonConverter<Rank, int> {
  const RankConverter();

  @override
  Rank fromJson(int json) => Rank.fromJson(json);

  @override
  int toJson(Rank rank) => rank.toJson();
}
