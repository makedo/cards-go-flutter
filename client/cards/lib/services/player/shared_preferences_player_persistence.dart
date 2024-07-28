import 'package:cards/services/player/player_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPlayerPersistence implements PlayerPersistence {
  SharedPreferencesPlayerPersistence();

  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<void> savePlayerId(String playerId) async {
    final instance = await instanceFuture;
    await instance.setString('playerId', playerId);
  }

  @override
  Future<String?> loadPlayerId() async {
    final instance = await instanceFuture;
    return instance.getString('playerId');
  }

  @override
  Future<void> deletePlayerId() async {
    final instance = await instanceFuture;
    await instance.remove('playerId');
  }
  
}
