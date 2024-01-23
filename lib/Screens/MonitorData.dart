// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    ]);
    super.dispose();
  }

  void getEventusingId() async {
    var response = await http.get(
      Uri.parse('$getEventById/$deviceId'),
    );
    jsonResponse = jsonDecode(response.body);
    print('Current Device ID: $deviceId');
    print(jsonResponse);
    if (jsonResponse['statusCode'] == 200) {
      setState(() {});
    } else {
      print('Invalid User Credential: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(255, 157, 0, 86),
                      ),
                      child: Row(
                        children: [
                          buildButton('Events'),
                          buildButton('Alarms'),
                          buildButton('Trends'),
                          buildButton('Logs'),
                        ],
                      ),
                    ),
                    Container(
                      height: 260,
                      width: 800,
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
        return buildEventsContent();
      case 'Alarms':
        return buildAlarmsContent();
      case 'Trends':
        return buildTrendsContent();
      case 'Logs':
        return buildLogsContent();
      default:
        return Container();
    }
  }

  Widget buildEventsContent() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildColumnHeading('Device ID'),
                  buildColumnHeading('Message'),
                  buildColumnHeading('Type'),
                  buildColumnHeading('Date'),
                  buildColumnHeading('Time'),
                ],
              ),
            ),
            Container(
              height: 0.1,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            for (var eventData in jsonResponse['data']['findDeviceById'])
              buildEventDataRow(eventData),
          ],
        ),
      ),
    );
  }

  Widget buildEventDataRow(Map<String, dynamic> eventData) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              buildColumnContent(builDeviceIdContent(eventData['did'])),
              SizedBox(
                width: 10,
              ),
              buildColumnContent(buildMsgContent(eventData['message'])),
              SizedBox(
                width: 20,
              ),
              buildColumnContent(buildTypeContent(eventData['type'])),
              buildColumnContent(buildDateContent(eventData['date'])),
              buildColumnContent(buildTimeContent(eventData['time'])),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 0.1,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
    );
  }

  Widget builDeviceIdContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildMsgContent(String text) {
    return SizedBox(
      width: 150,
      child: Text(
        text,
        maxLines: 3,
        softWrap: true,
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 218, 218, 218),
        ),
      ),
    );
  }

  Widget buildTypeContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildDateContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildTimeContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildColumnContent(Widget child) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          child,
        ],
      ),
    );
  }

  Widget buildColumnHeading(String heading) {
    return Text(
      heading,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildAlarmsContent() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Alarms Logs',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 218, 218, 218),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget buildTrendsContent() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Trends Logs',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 218, 218, 218),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget buildLogsContent() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Logs Found',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 218, 218, 218),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
