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

@JsonSerializable()
class DurenActionTake {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String type = 'take';
  final String playerId;

  DurenActionTake({
    required this.playerId,
  });

  factory DurenActionTake.fromJson(Map<String, dynamic> json) =>
      _$DurenActionTakeFromJson(json);

  Map<String, dynamic> toJson() => _$DurenActionTakeToJson(this);
}

@JsonSerializable()
class DurenActionConfirm {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String type = 'confirm';
  final String playerId;

  DurenActionConfirm({
    required this.playerId,
  });

  factory DurenActionConfirm.fromJson(Map<String, dynamic> json) =>
      _$DurenActionConfirmFromJson(json);

  Map<String, dynamic> toJson() => _$DurenActionConfirmToJson(this);
}
