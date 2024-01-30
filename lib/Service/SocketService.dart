import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  late io.Socket socket;

  void initializeSocket(String serverUrl, deviceId) {
    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('Connected to the server');
      socket.emit('FlutterConnected', {'message': 'Flutter client connected'});
    });

    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });

    socket.on('FlutterConnected', (data) {
      print('Server acknowledges Flutter client connection: $data');
    });
  }
}