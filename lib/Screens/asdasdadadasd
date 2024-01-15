// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/MDWidget.dart';
import 'package:http/http.dart' as http;

class MonitorData extends StatefulWidget {
  final Map<String, dynamic> deviceData;

  MonitorData(this.deviceData);

  @override
  _MonitorDataState createState() => _MonitorDataState();
}

class _MonitorDataState extends State<MonitorData> {
  late List<dynamic> deviceInfoList;

  String activeButton = 'Events';
  String activeButtonColor = 'Events';

  @override
  void initState() {
    super.initState();
    deviceInfoList = widget.deviceData['deviceInfo'];
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
    if (jsonResponse['statusCode'] == 200 ) {
    } else {
      print('Invalid User Credential: ${response.statusCode}');
    }}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                  child: MDWidget(deviceData: widget.deviceData),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 35,
                        width: 800,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
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
    Color buttonColor =
        isActive ? Colors.white : Color.fromARGB(255, 157, 0, 86);
    Color textColor = isActive ? Colors.black87 : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        alignment: Alignment.center,
        height: 32,
        width: 98,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
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
            padding: const EdgeInsets.only(left: 30, right: 50, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildColumnHeading('Device ID'),
                buildColumnHeading('Message'),
                buildColumnHeading('Type'),
                buildColumnHeading('Date'),
                buildColumnHeading('Time'),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 0.1,
            color: Colors.black,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: deviceInfoList.length,
            itemBuilder: (context, index) {
              var info = deviceInfoList[index];

              return Padding(
                padding: const EdgeInsets.only(left: 30, right: 0, top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // buildColumnContent('${info['DeviceId']}'),
                         buildColumnContent('${info['did']}'),
                    SizedBox(
                      width: 70,
                    ),
                    buildColumnContent('message'),
                    SizedBox(
                      width: 60,
                    ),
                    buildColumnContent('${info['DeviceType']}'),
                    SizedBox(
                      width: 40,
                    ),
                    buildColumnContent('Date'),
                    SizedBox(
                      width: 10,
                    ),
                    buildColumnContent('Time'),
                  ],
                ),
              );
            },
          ),
          Container(
            height: 0.1,
            color: Colors.black,
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
        color: Color.fromARGB(255, 58, 58, 58),
      ),
    );
  }

  Widget buildColumnContent(String content) {
    return Expanded(
      child: Text(
        content,
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 58, 58, 58),
        ),
      ),
    );
  }

  Widget buildAlarmsContent() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(              
                  'No Alarms Logs',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 58, 58, 58),
                  ),
                ),
              ],
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
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Trends Logs',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 58, 58, 58),
                  ),
                ),
              ],
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
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Logs Found',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 58, 58, 58),
                  ),
                ),
              ],
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
