import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService{
  String url;
  late WebSocketChannel _channel;
  late StreamController<dynamic> _streamController;
  late Timer _timer;
  WebsocketService(this.url) {
    _streamController = StreamController.broadcast();
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel.stream.listen(
          (message) {
        _streamController.add(jsonDecode(message));
      },
      onError: (error) {
        _streamController.addError(error);
      },
      onDone: () {
        _streamController.close();
      },
    );
  }
  Stream get stream => _streamController.stream;
  void startSendingMessages(String message){
    _timer =Timer.periodic(Duration(seconds: 5), (timer) {
      _channel.sink.add(message);
    });
  }
  void stopSendingMessages(){
    _timer.cancel();
  }
  void dispose() {
    _timer.cancel();
    _streamController.close();
    _channel.sink.close();
  }
}