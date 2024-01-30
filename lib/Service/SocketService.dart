// import 'package:socket_io_client/socket_io_client.dart' as io;

// class SocketServices {
//   static final SocketServices _instance = SocketServices._internal();
//    late Function(List<String> observedData) observerdataReceiver;

//   factory SocketServices() {
//     return _instance;
//   }

//   SocketServices._internal();

//   late io.Socket socket;
//   late String deviceId;

//    void setobserveDataReceived(Function(List<String>) callback) {
//     observerdataReceiver = callback;
//   }

//   void initializeSocket(String serverUrl, String deviceId) {
//     this.deviceId = deviceId;

//     socket = io.io(serverUrl, <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//     });

//     socket.on('connect', (data) {
//       print('Connected to the server');

//       socket.emit('ReactStartUp', this.deviceId);

//       socket.on('DataReceivingReact', (data) {
//         print("Received data from server: $data");

//         var modeData = data.split("^")[1];
//         var observedData = data.split("^")[2].split(",");
//         var setParameter = data.split("^")[3].split(",");
//         var secondaryObserved = data.split("^")[4].split(",");
//         var spo2List = data.split("^")[5].split(",");
//         var alertData = data.split("^")[6];
//         var batteryAlarmData = data.split("^")[7];
//         print(modeData);
//         print(observedData);
//         print(setParameter);
//         print(secondaryObserved);
//         print(spo2List);
//         print(alertData);
//         print(batteryAlarmData);

//          setobserveDataReceived(observedData);
//       });

//       // socket.on('DataGraphReceivingReact', (data) {
//       //   print("Received graphData from server: $data");

//       //   // var value = data.split("^")[0];
//       //   // if (value == deviceId) {
//       //   var graphdata = data.split("^")[1];
//       //   print(graphdata);
//       //   // List<FlSpot> socketData = (graphdata);
//       //   // LineChartWidget(socketData);
//       // });
//     });

//     socket.on('disconnect', (_) {
//       print('Disconnected from the server');
//     });
//   }
// }
