abstract class PlayerPersistence {
  Future<void> savePlayerId(String playerId);
  Future<String?> loadPlayerId();
  Future<void> deletePlayerId();
}
