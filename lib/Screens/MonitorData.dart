// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:agva_app/widgets/Alarms.dart';
import 'package:agva_app/widgets/Events.dart';
import 'package:agva_app/widgets/Trends.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/Calibration.dart';
import '../widgets/CrashLogs.dart';
import '../widgets/MDWidget.dart';
import 'package:http/http.dart' as http;

class MonitorData extends StatefulWidget {
  final String deviceId;
  final String wardNo;
  final String message;
  final String hospitalName;
  final String bioMed;
  final String departmentName;
  final String aliasName;

  MonitorData(this.deviceId, this.wardNo, this.message, this.hospitalName,
      this.bioMed, this.departmentName, this.aliasName);

  @override
  _MonitorDataState createState() => _MonitorDataState();
}

class _MonitorDataState extends State<MonitorData> {
  bool isLoading = true;
  late String deviceId;
  late String wardNo;
  late String message;
  late String hospitalName;
  late String bioMed;
  late String departmentName;
  late String aliasName;
  String activeButton = 'Events';
  String activeButtonColor = 'Events';
  late Map<String, dynamic> jsonResponse;

  @override
  void initState() {
    super.initState();
    deviceId = widget.deviceId;
    wardNo = widget.wardNo;
    message = widget.message;
    hospitalName = widget.hospitalName;
    bioMed = widget.bioMed;
    departmentName = widget.departmentName;
    aliasName = widget.aliasName;
    getEventusingId();
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

  Future<void> getEventusingId() async {
    var response = await http.get(
      Uri.parse('$getDeviceEventbyID/$deviceId'),
    );
    jsonResponse = jsonDecode(response.body);
    print('Current Device ID: $deviceId');
    // print(jsonResponse);
    if (jsonResponse['statusCode'] == 200) {
      setState(() {
        isLoading = false;
      });
    } else {
      print('Invalid User Credential: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: MDWidget(
                      widget.wardNo,
                      widget.message,
                      widget.hospitalName,
                      widget.bioMed,
                      widget.departmentName,
                      widget.aliasName),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        width: 800,
              //                         height: MediaQuery.of(context).size.height * 0.11,
              // width: MediaQuery.of(context).size.width * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(255, 157, 0, 86),
                        ),
                        child: Row(
                          children: [
                            buildButton('Events'),
                            buildButton('Alarms'),
                            buildButton('Crash Logs'),
                            buildButton('Trends'),
                            buildButton('Calibration'),
                          ],
                        ),
                      ),
                      Container(
                        // height: 280,
                        // width: 800,
                                      height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(255, 65, 65, 65),
                        ),
                        child: buildBigContainerContent(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String buttonName) {
    bool isActive = activeButton == buttonName;
    Color buttonColor = isActive
        ? Color.fromARGB(255, 249, 249, 249)
        : Color.fromARGB(255, 157, 0, 86);
    Color textColor = isActive ? Colors.black87 : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        alignment: Alignment.center,
        height: 32,
        width: 98,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: buttonColor,
        ),
        child: GestureDetector(
          onTap: () {
            setActiveButton(buttonName);
          },
          child: Text(
            buttonName,
            style: TextStyle(
                color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void setActiveButton(String button) {
    setState(() {
      activeButton = button;
    });
  }

  Widget buildBigContainerContent() {
    switch (activeButton) {
      case 'Events':
        return isLoading ? buildLoading() : Events(deviceId);
      case 'Alarms':
        return isLoading ? buildLoading() : Alarms(deviceId);
      case 'Crash Logs':
        return isLoading ? buildLoading() : CrashLogs(deviceId);
      case 'Trends':
        return isLoading ? buildLoading() : Trends(deviceId);
      case 'Calibration':
        return isLoading ? buildLoading() : Calibration(deviceId);
      default:
        return Container();
    }
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
