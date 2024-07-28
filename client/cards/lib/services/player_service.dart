import 'package:cards/services/player/player_persistence.dart';
import 'package:cards/services/player/shared_preferences_player_persistence.dart';
import 'package:uuid/uuid.dart';

class PlayerService {
  final PlayerPersistence _playerPersistence;

  PlayerService(this._playerPersistence);

  factory PlayerService.shared() {
    return PlayerService(SharedPreferencesPlayerPersistence());
  }

  Future<String> getPlayerId() async {
    var playerId = await _playerPersistence.loadPlayerId();

    if (playerId == null) {
      playerId = const Uuid().v4();
      await _playerPersistence.savePlayerId(playerId);
    }

    return playerId;
  }

  Future<void> deletePlayerId() async {
    await _playerPersistence.deletePlayerId();
  }
}
