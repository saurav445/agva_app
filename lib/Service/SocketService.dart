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
  late void Function(
    String,
    List<String>,
    List<String>,
    List<String>,
    // List<String>,
    // String,
    // String,
  ) onDataReceived;

  void setOnDataReceivedCallback(
      void Function(
        String,
        List<String>,
        List<String>,
        List<String>,
        // List<String>,
        // String,
        // String,
      ) callback) {
    onDataReceived = callback;
  }

  late void Function(String, String, String, String, String, String, String, String, String, String, 
      String, String, String) tilesData;

  void tilesDataCallBack(
      void Function(String, String, String, String, String, String, String,String, String, String, 
              String, String, String)
          callback) {
    tilesData = callback;
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

      socket.on('DataReceivingReact', (data) {
        var modeData = data.split("^")[1];
        var observedData = data.split("^")[2].split(",");
        var setParameter = data.split("^")[3].split(",");
        var secondaryObserved = data.split("^")[4].split(",");
        var spo2List = data.split("^")[5].split(",");
        var spo2value = spo2List[1].split("~")[1];
        var pulseValue = spo2List[0].split("~")[1];
        var pip = observedData[1].split("~")[0];
        var pipValue = observedData[1].split("~")[1];
        var vti = observedData[4].split("~")[0];
        var vtiValue = observedData[4].split("~")[1];
        var mVi = observedData[7].split("~")[0];
        var mViValue = observedData[7].split("~")[1];
        var rr = observedData[10].split("~")[0];
        var rrValue = observedData[10].split("~")[1];
        var fiO2 = observedData[3].split("~")[0];
        var fiO2Value = observedData[3].split("~")[1];
        // var alertData = data.split("^")[6];
        // var batteryAlarmData = data.split("^")[7];
        tilesData(pip, pipValue, vti, vtiValue, mVi, mViValue, rr, rrValue,
            spo2value, pulseValue, fiO2, fiO2Value, modeData);
        onDataReceived(
          modeData,
          observedData,
          setParameter,
          secondaryObserved,
        );
      });
    });

    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });
  }
}
