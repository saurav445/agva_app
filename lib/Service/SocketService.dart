// import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketServices {
  static final SocketServices _instance = SocketServices._internal();

  factory SocketServices() {
    return _instance;
  }

  SocketServices._internal();

  late io.Socket socket;
  late String deviceId;


  late void Function(double, double, double, List<String>) onGraphDataReceived;

  setOnGraphDataReceivedCallback(
      void Function(double, double, double, List<String>) callback) {
    onGraphDataReceived = callback;
  }

  void Function(String, List<String>, List<String>, List<String>, String,
      String, String)? onDataReceived;

  void setOnDataReceivedCallback(
      void Function(String, List<String>, List<String>, List<String>, String,
              String, String)
          callback) {
    onDataReceived = callback;
  }

  late void Function(String, String, String, String, String, String, String,
      String, String, String, String, String, String)? tilesData;

  void tilesDataCallBack(
      void Function(String, String, String, String, String, String, String,
              String, String, String, String, String, String)
          callback) {
    tilesData = callback;
  }

  void initializeSocket(String url, String deviceId) {
    this.deviceId = deviceId;

    print("NOW HERE IN SOCKET");
    socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();

    socket.onConnect((_) {
      socket.emit('ReactStartUp', 'this.deviceId');
      print("This is called to receive data");
    });

    socket.on('connect', (data) {
      print('Connected to the server');
      print(data);
      print("THIS RUN HERE");

      socket.emit('ReactStartUp', 'this.deviceId');

      socket.on('DataGraphReceivingReact', (data) {
        var graphDataString = data.split("^")[1];

        List<String> graphDataList = graphDataString.split(",");
        double pressure = double.parse(graphDataList[1]);
        double volume = double.parse(graphDataList[2]);
        double flow = double.parse(graphDataList[3]);

        onGraphDataReceived(pressure, volume, flow, graphDataList);
      });

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
        var alertData = data.split("^")[6];
        var alarmName = alertData.split("~")[0];
        var alarmColor = alertData.split("~")[1];
        var alarmColor2 = alertData.split("~")[2];

        tilesData!(pip, pipValue, vti, vtiValue, mVi, mViValue, rr, rrValue,
            spo2value, pulseValue, fiO2, fiO2Value, modeData);

        onDataReceived!(modeData, observedData, setParameter, secondaryObserved,
            alarmName, alarmColor, alarmColor2);
      });
    });

    // connect();

    // socket.on('disconnect', (data) {
    //   socket.emit('ReactNodeStop', this.deviceId);
    //         print(data);
    //   print('Disconnected from the server');

    // });
  }

  void connect() {
    if (!socket.disconnected) {
      socket.connect();
    }
  }

  void dispose() {
    socket.emit('ReactNodeStop', this.deviceId);
    socket.onDisconnect((_) => print(" Disconnected from server"));
    socket.onclose(this.deviceId);
    //socket.disconnect(); // Disconnect from the server
    socket.dispose(); // Dispose of the socket
  }
}
