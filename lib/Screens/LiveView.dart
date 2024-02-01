// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, unused_import, unnecessary_string_interpolations, use_key_in_widget_constructors
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:agva_app/Screens/DeviceDetails.dart';
import 'package:agva_app/widgets/LineChartWidget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Service/SocketService.dart';

class LiveView extends StatefulWidget {
  final String deviceId;
  LiveView(this.deviceId);

  @override
  _LiveViewState createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  String selectedMenu = 'DATA';
  late String deviceId;
  late String modeData = '-';
  late List<String> observedData;
  late List<String> setParameter;
  late List<String> secondaryObserved;
  // late String alertData;

  @override
  void initState() {
    super.initState();
    SocketServices socketService = SocketServices();
    socketService.initializeSocket(
        'http://192.168.92.71:8000', widget.deviceId);
    socketService.setOnDataReceivedCallback((
      receivedModeData,
      receivedObservedData,
      receivedSetParameter,
      receivedSecondaryObserved,
      // receivedSpo2List,
      // receivedAlertData,
      // receivedBatteryAlarmData,
    ) {
      setState(() {
        modeData = receivedModeData;
        observedData = receivedObservedData;
        secondaryObserved = receivedSecondaryObserved;
        setParameter = receivedSetParameter;
        // alertData = receivedAlertData;

        print(observedData);
      });
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: modeData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('Fetching mode data...'),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //header
                        Header(modeData),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.002,
                        ),
                        //buttons & graphs & tiles
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Side menu buttons
                            MenuButtons(
                              selectedMenu,
                              (menu) {
                                setState(() {
                                  selectedMenu = menu;
                                });
                              },
                            ),

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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Data screen
                                    if (selectedMenu == 'DATA')
                                      DataScreen(observedData: observedData),

//graphContainer
                                    if (selectedMenu == 'GRAPHS')
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.73,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                        // child: LineChartWidget(
                                        //   xvalue,
                                        //   pressure,
                                        //   volume,
                                        //   flow,
                                        // ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.002,
                            ),

                            //secondaryobserverdata tiles
                            Tiles(secondaryObserved),
                          ],
                        ),

                        BottomTiles(setParameter),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButtons extends StatelessWidget {
  final String selectedMenu;
  final Function(String) onMenuSelected;

  MenuButtons(this.selectedMenu, this.onMenuSelected);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildMenuButton(context, 'DATA'),
        buildMenuButton(context, 'ALARMS'),
        buildMenuButton(context, 'LOOPS'),
        buildMenuButton(context, 'GRAPHS'),
        buildMenuButton(context, 'MODES'),
        buildMenuButton(context, 'CONTROLS'),
        buildMenuButton(context, 'SYSTEM'),
      ],
    );
  }

  Widget buildMenuButton(BuildContext context, String menu) {
    bool isSelected = selectedMenu == menu;
    return GestureDetector(
      onTap: () {
        onMenuSelected(menu);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.1,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Color.fromARGB(255, 8, 8, 8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                menu,
                style: TextStyle(
                  fontFamily: 'Avenir',
                  color: isSelected
                      ? Colors.black
                      : Color.fromARGB(255, 218, 218, 218),
                  fontSize: MediaQuery.of(context).size.width * 0.015,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataScreen extends StatelessWidget {
  const DataScreen({
    Key? key,
    required this.observedData,
  }) : super(key: key);

  final List<String> observedData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0,
          ),
          itemCount: observedData.length,
          itemBuilder: (BuildContext context, int index) {
            String data = observedData[index];
            List<String> dataParts = data.split('~');
            String label = dataParts[0];
            String value = dataParts[1];
            
            bool isMachine = value.contains('Machine');
            return Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          label.isEmpty ? '-' : label,
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 136, 136, 136),
                            fontSize: MediaQuery.of(context).size.width * 0.01,
                          ),
                        ),
                        Text(
                          isMachine ? 'M' : '$value',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 218, 218, 218),
                            fontSize: MediaQuery.of(context).size.width * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  late String modeData;
  Header(this.modeData);

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
                  modeData.isEmpty ? '-' : modeData,
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
              GestureDetector(
                onTap: () => {Navigator.pop(context)},
                child: Image.asset(
                  "assets/images/exit.png",
                  height: 20,
                  fit: BoxFit.cover,
                ),
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

class BottomTiles extends StatelessWidget {
  final List<String> setParameter;

  const BottomTiles(this.setParameter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 8, 8, 8),
      ),
      child: Row(
        children: setParameter.map((parameter) {
          var splitParameter = parameter.split('~');
          var parameterName = splitParameter[0];
          var parameterValue = splitParameter[1];

          return Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width * 0.12,
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: const Color.fromARGB(255, 90, 90, 90),
                ),
              ),
              color: Color.fromARGB(255, 8, 8, 8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    parameterName,
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 136, 136, 136),
                      fontSize: MediaQuery.of(context).size.width * 0.012,
                    ),
                  ),
                  Text(
                    parameterValue,
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 218, 218, 218),
                      fontSize: MediaQuery.of(context).size.width * 0.022,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Tiles extends StatelessWidget {
  final List<String> secondaryObserved;

  Tiles(this.secondaryObserved);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: secondaryObserved.map((data) {
        var keyValuePairs = data.split(', ');
        Map<String, String> valuesMap = {};
        keyValuePairs.forEach((pair) {
          var splitPair = pair.split('~');
          valuesMap[splitPair[0]] = splitPair[1];
        });

        return Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width * 0.16,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 90, 90, 90)),
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: valuesMap.entries.map((entry) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: MediaQuery.of(context).size.width * 0.012,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.022,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}
