// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class Alarms extends StatefulWidget {
//   final String deviceId;
//   const Alarms(this.deviceId);

//   @override
//   State<Alarms> createState() => _AlarmsState();
// }

// class _AlarmsState extends State<Alarms> {
//   bool isLoading = true;
//   late String deviceId;
//   late Map<String, dynamic> jsonResponse;

//   @override
//   void initState() {
//     super.initState();
//     deviceId = widget.deviceId;
//     getAlarmbyId();
//   }

//   Future<void> getAlarmbyId() async {
//     var response = await http.get(
//       Uri.parse('$getDeviceAlarmsbyID/$deviceId'),
//     );
//     jsonResponse = jsonDecode(response.body);
//     print('Current Device ID: $deviceId');
//     if (jsonResponse['statusCode'] == 200) {
//       setState(() {
//         isLoading = false;
//       });
//     } else {
//       print('Invalid User Credential: ${response.statusCode}');
//     }
//   }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(width: 20),
              buildColumnContent(buildDeviceIdContent(alarmData['did'])),
              buildColumnContent(buildCodeContent(alarmData['ack']['code'])),
              buildColumnContent(buildMsgContent(alarmData['ack']['msg'])),
                         SizedBox(width: 10),
              buildColumnContent(buildPriContent(alarmData['priority'])),
              buildColumnContent(buildDateContent(alarmData['ack']['date'])),
              buildColumnContent(buildTimeContent(alarmData['ack']['time'])),
            ],
          ),
          SizedBox(height: 10),
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
      width: 100,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 218, 218, 218),
        ),
      ),
    );
  }

//priority
  Widget buildPriContent(String text) {
    return Container(
      height: 7,
      child: Image.asset(
        getImagePath(text),
      ),
    );
  }

  String getImagePath(String priority) {
    switch (priority) {
      case 'ALARM_LOW_LEVEL':
        return "assets/images/LowAlarm.png";
      case 'ALARM_MEDIUM_LEVEL':
        return "assets/images/MediumAlarm.png";
      case 'ALARM_HIGH_LEVEL':
        return "assets/images/HighAlarm.png";
      default:
        return "assets/images/LowAlarm.png";
    }
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

//   Widget buildColumnContent(Widget child) {
//     return Expanded(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           child,
//         ],
//       ),
//     );
//   }

//   Widget buildColumnHeading(String heading) {
//     return Text(
//       heading,
//       style: TextStyle(
//         fontSize: 12,
//         color: Color.fromARGB(255, 218, 218, 218),
//       ),
//     );
//   }
// }
