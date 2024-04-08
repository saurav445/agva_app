// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Alarms extends StatefulWidget {
  final String deviceId;
  const Alarms(this.deviceId);

  @override
  State<Alarms> createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {
  bool isLoading = true;
  late String deviceId;
  late Map<String, dynamic> jsonResponse;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    deviceId = widget.deviceId;
    getAlarmbyId(currentPage);
  }

  Future<void> getAlarmbyId(currentPage) async {
    var response = await http.get(
      Uri.parse('$getDeviceAlarmsbyID/$deviceId?page=$currentPage&limit=5'),
    );
    jsonResponse = jsonDecode(response.body);
    print('Current Device ID: $deviceId');
    if (jsonResponse['statusCode'] == 200) {
      setState(() {
        isLoading = false;
      });
    } else {
      print('Invalid User Credential: ${response.statusCode}');
    }
  }
   void next() {
    {
      currentPage++;
      getAlarmbyId(currentPage);
    }
  }


  void back() {
    {
      currentPage--;
      getAlarmbyId(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: Color.fromARGB(255, 58, 58, 58),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildColumnHeading('Code'),
                buildColumnHeading('Alarm'),
                buildColumnHeading('Priority'),
                buildColumnHeading('Date'),
                buildColumnHeading('Time'),
              ],
            ),
          ),
          Container(
            height: 0.1,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          if (isLoading) // Show loading indicator
            buildEmptyContainer2()
          else if (jsonResponse['data']['findDeviceById']
              .isEmpty) // Show "No Alarm Logs" message
            buildEmptyContainer()
          else
            for (var alarmData in jsonResponse['data']['findDeviceById'])
              buildAlarmDataRow(alarmData),
        ],
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        // width: 150,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Color.fromARGB(0, 0, 0, 0)),

        child: Row(
          children: [
            if (currentPage >= 2)
              FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 1,
                onPressed: back,
                child: Icon(Icons.arrow_left_outlined),
              ),
            SizedBox(
              width: 10,
            ),
            if (currentPage >= 2) Text(currentPage.toString()),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 1,
              onPressed: next,
              child: Icon(Icons.arrow_right_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyContainer2() {
    return Padding(
        padding: const EdgeInsets.only(top: 80),
        child: CircularProgressIndicator());
  }

  Widget buildAlarmDataRow(Map<String, dynamic> alarmData) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 40),
              buildColumnContent(buildCodeContent(alarmData['ack']['code'])),
              buildColumnContent(buildMsgContent(alarmData['ack']['msg'])),
              SizedBox(width: 10),
              buildColumnContent(buildPriContent(alarmData['priority'])),
              buildColumnContent(buildDateContent(alarmData['ack']['date'])),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 40),
                child: buildColumnContent(buildTimeContent(alarmData['ack']['time'])),
              ),
            ],
          ),
          SizedBox(height: 15),
          Container(
            height: 0.1,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget buildEmptyContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
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
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildDeviceIdContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildCodeContent(String text) {
    return Text(
      text,
      maxLines: 3,
      softWrap: true,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildMsgContent(String text) {
    return SizedBox(
      width: 120,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 218, 218, 218),
        ),
      ),
    );
  }

  Widget buildPriContent(String text) {
    return getAlarmContainer(text);
  }

  Widget getAlarmContainer(String priority) {
    switch (priority) {
      case 'ALARM_LOW_LEVEL':
        return buildLowAlarm();
      case 'ALARM_MEDIUM_LEVEL':
        return buildMediumAlarm();
      case 'ALARM_HIGH_LEVEL':
        return buildHighAlarm();
      case 'ALARM_CRITICAL_LEVEL':
        return buildHighAlarm();
      default:
        return buildLowAlarm();
    }
  }

  Widget buildLowAlarm() {
    return Container(
      height: 7,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      color: Color.fromARGB(255, 255, 166, 0),
      ),
    );
  }

  Widget buildMediumAlarm() {
    return Container(
      height: 7,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 255, 166, 0),
      ),
    );
  }

  Widget buildHighAlarm() {
    return Container(
      height: 7,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 255, 17, 0),
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
        mainAxisAlignment: MainAxisAlignment.start,
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
}
