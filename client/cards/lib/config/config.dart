import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static load() async {
    await dotenv.load();

    const requiredEnvVars = ['WS_URL'];
    if (!dotenv.isEveryDefined(requiredEnvVars)) {
      throw Exception('Missing required environment variables');
    }
  }

  static String get wsUrl => dotenv.get('WS_URL');
}
