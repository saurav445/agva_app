// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, unused_import
import 'package:agva_app/widgets/chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketServices {
  static final SocketServices _instance = SocketServices._internal();

  factory SocketServices() {
    return _instance;
  }

  SocketServices._internal();

  late io.Socket socket;
  late String deviceId;

  late String modeData;
  // late List<String> observedData;
  // late List<String> setParameter;
  // late List<String> secondaryObserved;
  // late List<String> spo2List;
  // late String alertData;
  // late String batteryAlarmData;

  late void Function(String) onDataReceived;

  void setOnDataReceivedCallback(void Function(String) callback) {
    onDataReceived = callback;
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
    modeData = data.split("^")[1];
    onDataReceived(modeData); // Call the callback to notify the UI
  });

      // socket.on('DataReceivingReact', (data) {
      //   // print("Received data from server: $data");

      //   // var modeData = data.split("^")[1];
      //   // var observedData = data.split("^")[2].split(",");
      //   // var setParameter = data.split("^")[3].split(",");
      //   // var secondaryObserved = data.split("^")[4].split(",");
      //   // var spo2List = data.split("^")[5].split(",");
      //   // var alertData = data.split("^")[6];
      //   // var batteryAlarmData = data.split("^")[7];
      //   // print(modeData);
      //   // print(observedData);
      //   // print(setParameter);
      //   // print(secondaryObserved);
      //   // print(spo2List);
      //   // print(alertData);
      //   // print(batteryAlarmData);
        
      // });
      
    });

    socket.on('disconnect', (_) {
      print('Disconnected from the server');
      
    });
    
  }
  
}

class LiveView extends StatefulWidget {
  final String deviceId;
  LiveView(this.deviceId);

  @override
  _LiveViewState createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  List<FlSpot> socketData = [];
  late String deviceId;
  late String modeData;

  @override
  void initState() {
    super.initState();
    deviceId = widget.deviceId;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SocketServices socketService = SocketServices();
    socketService.initializeSocket('http://192.168.2.1:8000', widget.deviceId);
    socketService.setOnDataReceivedCallback((data) {
      setState(() {
        modeData = data; 
        print(modeData);
      });
    });
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SocketServices()
    //     .initializeSocket('http://192.168.2.1:8000', widget.deviceId);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //header
                Header(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.003,
                ),
                //buttons & graphs & tiles
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Side menu buttons
                    MenuButtons(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.002,
                    ),
                    //graph screen
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.73,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.73,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 35, 35, 35),
                              ),
                              child: LineChartWidget(socketData),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.73,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 35, 35, 35),
                              ),
                              child: LineChartWidget(socketData),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.73,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 35, 35, 35),
                              ),
                              child: LineChartWidget(socketData),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.002,
                    ),
                    //tiles
                  Tiles(modeData),
                  ],
                ),

                BottomTiles(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Tiles extends StatelessWidget {
late String modeData;
  Tiles(String modeData);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width * 0.16,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 90, 90, 90)),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'PIP',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      'cmH2O',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
                Text(
                  // '20',
                  modeData ?? '20',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width * 0.16,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 90, 90, 90)),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'PEEP',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      'cmH2O',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
                Text(
                  '5',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width * 0.16,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 90, 90, 90)),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'VTi',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      'ml',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
                Text(
                  '150',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width * 0.16,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 90, 90, 90)),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'RR',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      'bpm',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
                Text(
                  '16',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width * 0.16,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 90, 90, 90)),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'FiO2',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
                Text(
                  '21',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BottomTiles extends StatelessWidget {
  const BottomTiles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 8, 8, 8),
        ),
        child: Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical: BorderSide(
                        color: const Color.fromARGB(255, 90, 90, 90))),
                color: Color.fromARGB(255, 8, 8, 8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'FiO2',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      '20',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical: BorderSide(
                        color: const Color.fromARGB(255, 90, 90, 90))),
                color: Color.fromARGB(255, 8, 8, 8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'RR',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      '16',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ),
                    Text(
                      'bpm',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical:
                        BorderSide(color: Color.fromARGB(255, 71, 64, 64))),
                color: Color.fromARGB(255, 8, 8, 8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Trigger',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      '5.0',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ),
                    Text(
                      'l/min',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical: BorderSide(
                        color: const Color.fromARGB(255, 90, 90, 90))),
                color: Color.fromARGB(255, 8, 8, 8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'PEEP',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      '5',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ),
                    Text(
                      'cmH2O',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical: BorderSide(
                        color: const Color.fromARGB(255, 90, 90, 90))),
                color: Color.fromARGB(255, 8, 8, 8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Psupp',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      '10',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ),
                    Text(
                      'cmH2O',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.11,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                border: Border.symmetric(
                    vertical: BorderSide(
                        color: const Color.fromARGB(255, 90, 90, 90))),
                color: Color.fromARGB(255, 8, 8, 8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pinsp',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      '14',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ),
                    Text(
                      'cmH2O',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.04,
            ),
            Image.asset(
              "assets/images/add.png",
              height: 20,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButtons extends StatelessWidget {
  const MenuButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'DATA',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ALARMS',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'LOOPS',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'GRAPHS',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'MODES',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'CONTROLS',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SYSTEM',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //mode
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Color.fromARGB(255, 32, 76, 0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'PC-SIMV',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.015,
          ),

          //patient details
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'UHID22554484',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.006,
                      ),
                    ),
                    Text(
                      '45 Years',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.006,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.015,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '33 cms',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.006,
                      ),
                    ),
                    Text(
                      '52 kg',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.006,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.015,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '09-12-2023',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.006,
                      ),
                    ),
                    Text(
                      '00:08:25',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.006,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.015,
          ),

          //alarm box
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromARGB(255, 188, 138, 0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'No 02 Supply',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.015,
          ),

          //action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/images/alarm.png",
                height: 20,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.015,
              ),
              Image.asset(
                "assets/images/bettery.png",
                height: 20,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.015,
              ),
              Image.asset(
                "assets/images/charge.png",
                height: 20,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.015,
              ),
              Image.asset(
                "assets/images/exit.png",
                height: 20,
                fit: BoxFit.cover,
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.015,
          ),

          // pr spo2
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            width: MediaQuery.of(context).size.width * 0.16,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 90, 90, 90)),
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'PR',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      '-',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.006,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'SpO2',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ),
                    Text(
                      '-',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.006,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
