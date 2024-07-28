import 'dart:convert';

import 'package:cards/config/config.dart';
import 'package:cards/services/websocket/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService {
  late WebSocketChannel _channel;

  Future<void> connect(String playerId) async {
    _channel = WebSocketChannel.connect(
      Uri.parse('${Config.wsUrl}?playerId=$playerId'),
    );

    return _channel.ready;
  }

  void disconnect() {
    _channel.sink.close();
  }

  void send(Message message) {
    var messageJson = jsonEncode(message);
    _channel.sink.add(messageJson);
  }

  void listen(void Function(dynamic event) callback,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) async {
    _channel.stream.listen(callback,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
