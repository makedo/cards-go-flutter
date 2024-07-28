import 'package:cards/services/websocket/message.dart';
import 'package:json_annotation/json_annotation.dart';
part 'duren_actions.g.dart';

@JsonSerializable(includeIfNull: true)
class DurenActionMove implements Message {
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

  @override
  Map<String, dynamic> toJson() => _$DurenActionMoveToJson(this);
}

@JsonSerializable()
class DurenActionTake implements Message {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String type = 'take';
  final String playerId;

  DurenActionTake({
    required this.playerId,
  });

  factory DurenActionTake.fromJson(Map<String, dynamic> json) =>
      _$DurenActionTakeFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DurenActionTakeToJson(this);
}

@JsonSerializable()
class DurenActionConfirm implements Message {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String type = 'confirm';
  final String playerId;

  DurenActionConfirm({
    required this.playerId,
  });

  factory DurenActionConfirm.fromJson(Map<String, dynamic> json) =>
      _$DurenActionConfirmFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DurenActionConfirmToJson(this);
}

@JsonSerializable()
class DurenActionReady implements Message {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String type = 'ready';
  final String playerId;

  DurenActionReady({
    required this.playerId,
  });

  factory DurenActionReady.fromJson(Map<String, dynamic> json) =>
      _$DurenActionReadyFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DurenActionReadyToJson(this);
}

@JsonSerializable()
class DurenActionJoin implements Message {
  @JsonKey(includeFromJson: false, includeToJson: true)
  final String type = 'join';
  final String playerId;

  DurenActionJoin({
    required this.playerId,
  });

  factory DurenActionJoin.fromJson(Map<String, dynamic> json) =>
      _$DurenActionJoinFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DurenActionJoinToJson(this);
}
