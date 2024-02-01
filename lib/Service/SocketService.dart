import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketServices {
  static final SocketServices _instance = SocketServices._internal();

  factory SocketServices() {
    return _instance;
  }

  SocketServices._internal();

  late io.Socket socket;
  late String deviceId;

//for values
  late void Function(String, List<String>, List<String>, List<String>,
      List<String>, String, String) onDataReceived;

  void setOnDataReceivedCallback(
      void Function(String, List<String>, List<String>, List<String>,
              List<String>, String, String)
          callback) {
    onDataReceived = callback;
  }

// for graph
  late void Function(int, double, double, double, List<String>) onGraphReceived;

  void setOnGraphReceivedCallback(
      void Function(int, double, double, double, List<String>) callback) {
    onGraphReceived = callback;
  }

  void initializeSocket(String serverUrl, String deviceId) {
    this.deviceId = deviceId;

    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (data) {
      print('Connected to the server');

      socket.emit('ReactStartUp', this.deviceId);

      socket.on('DataGraphReceivingReact', (data) {
        var graphDataString = data.split("^")[1];
        List<String> graphDataList = graphDataString.split(",");
        double xvalue = double.parse(graphDataList[0]);
        double pressure = double.parse(graphDataList[1]);
        double volume = double.parse(graphDataList[2]);
        double flow = double.parse(graphDataList[3]);

        // print("X: $xvalue");
        // print("Pressure: $pressure");
        // print("Volume: $volume");
        // print("Flow: $flow");

        onGraphReceived(xvalue.toInt(), pressure, volume, flow, graphDataList);
      });

      socket.on('DataReceivingReact', (data) {
        var modeData = data.split("^")[1];
        var observedData = data.split("^")[2].split(",");
        var setParameter = data.split("^")[3].split(",");
        var secondaryObserved = data.split("^")[4].split(",");
        var spo2List = data.split("^")[5].split(",");
        var alertData = data.split("^")[6];
        var batteryAlarmData = data.split("^")[7];

        onDataReceived(modeData, observedData, setParameter, secondaryObserved,
            spo2List, alertData, batteryAlarmData);
      });
    });

    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });
  }
}