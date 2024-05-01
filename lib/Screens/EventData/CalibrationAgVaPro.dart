// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Calibration extends StatefulWidget {
  final String deviceId;
  const Calibration(this.deviceId);

  @override
  State<Calibration> createState() => _CalibrationState();
}

class _CalibrationState extends State<Calibration> {
  bool isLoading = true;
  late String deviceId;
  late Map<String, dynamic> jsonResponse;

  @override
  void initState() {
    super.initState();
    deviceId = widget.deviceId;
    getCalibrationbyId();
  }

  Future<void> getCalibrationbyId() async {
    var response = await http
        .get(Uri.parse('$getDeviceCalibyID/$deviceId?page=1&limit=5'));
    jsonResponse = jsonDecode(response.body);
    print('Current Device ID: $deviceId');
    if (jsonResponse['statusCode'] == 200) {
      print(jsonResponse);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        print(jsonResponse['message']);
      });
    }
  }

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
                  buildColumnHeading('Name'),
                  buildColumnHeading('Message'),
                  buildColumnHeading('Date'),
                  buildColumnHeading('Time'),
                ],
              ),
            ),
            Container(
              height: 0.1,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            if (isLoading)
              buildEmptyContainer2()
            else if (jsonResponse['statusCode'] > 400)
              buildEmptyContainer()
            else
              for (var calbData in jsonResponse['data'])
                buildCaliDataRow(calbData),
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

  Widget buildCaliDataRow(dynamic calbData) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10),
              buildColumnContent(buildNameContent(calbData['name'])),
              SizedBox(width: 10),
              buildColumnContent(buildMsgContent(calbData['message'])),
              SizedBox(width: 10),
              buildColumnContent(buildDateContent(calbData['date'])),
              buildColumnContent(buildTimeContent(calbData['time'])),
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
      child: Text(
        'No Calibration Data',
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 218, 218, 218),
        ),
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

  Widget buildNameContent(String text) {
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

  Widget buildMsgContent(String text) {
    Color backgroundColor;

    if (text == "SUCCESS") {
      backgroundColor = Color.fromARGB(255, 43, 199, 0);
    } else if (text == "FAILED") {
      backgroundColor = const Color.fromARGB(255, 255, 17, 0);
    } else {
      backgroundColor = Color.fromARGB(255, 43, 199, 0);
    }

    return Container(
      width: 100,
      // height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            maxLines: 3,
            softWrap: true,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
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
}
