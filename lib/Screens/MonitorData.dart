// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/MDWidget.dart';
import 'package:http/http.dart' as http;

class MonitorData extends StatefulWidget {
  @override
  _MonitorDataState createState() => _MonitorDataState();
}

class _MonitorDataState extends State<MonitorData> {
  String activeButton = 'Events';
  String activeButtonColor = 'Events';

  @override
  void initState() {
    super.initState();
    getEventusingId();
  }

  Future<String?> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('deviceId');
  }

  void getEventusingId() async {
    String? deviceId = await getDeviceId();
    if (deviceId != null) {
      var response = await http.get(
        Uri.parse('$getEventById/$deviceId'),
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusCode'] == 200) {
      } else {
        print('Invalid User Credential: ${response.statusCode}');
      }
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
                child: MDWidget(),
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
                      height: 250,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // buildColumnContent('${info['DeviceId']}'),
                buildColumnContent('deviceId'),
                buildColumnContent('Message'),
                buildColumnContent('Type'),
                buildColumnContent('Date'),
                buildColumnContent('Time'),
              ],
            ),
          ),
          Container(
            height: 0.1,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
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

  Widget buildColumnContent(String content) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            content,
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 218, 218, 218),
            ),
          ),
        ],
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
