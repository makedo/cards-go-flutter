import 'package:json_annotation/json_annotation.dart';
part 'duren_actions.g.dart';

@JsonSerializable(includeIfNull: true)
class DurenActionMove {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String type = 'move';
  final int cardId;
  final String playerId;
  final int? tableIndex;

  DurenActionMove({
    required this.cardId,
    required this.playerId,
    this.tableIndex,
  });

  factory DurenActionMove.fromJson(Map<String, dynamic> json) =>
      _$DurenActionMoveFromJson(json);

  Map<String, dynamic> toJson() => _$DurenActionMoveToJson(this);
}
