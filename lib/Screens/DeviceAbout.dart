// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:convert';
import 'package:agva_app/Screens/DeviceDetails.dart';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceAbout extends StatefulWidget {
  final String deviceId;
  final String deviceType;

  DeviceAbout(this.deviceId, this.deviceType);

  @override
  _DeviceAboutState createState() => _DeviceAboutState();
}

class _DeviceAboutState extends State<DeviceAbout> {
  Map<String, dynamic> deviceAbout = {};
  late String deviceId;
  late String deviceType;

  @override
  void initState() {
    super.initState();
    deviceId = widget.deviceId;
    deviceType = widget.deviceType;
    getProductionDetails();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    print('Saved Token: $mytoken');
    return mytoken;
  }

  void getProductionDetails() async {
    String? token = await getToken();
    if (token != null) {
      var response = await http.get(
        Uri.parse('$getProductionData/$deviceId'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        setState(() {
          deviceAbout = jsonResponse['data'];
        });
      } else {
        print('Invalid User Credential: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 40,
                    child: Image.asset("assets/images/back.png"),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: Column(
                      children: [
                        Text(
                          widget.deviceType ?? 'N/A',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 24,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Text(
                          "About",
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Model :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Delivery Date :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Date of Manufacture :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Batch No :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Date of Warranty :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Last Service :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    deviceAbout['productType'] ?? 'N/A',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['model'] ?? 'N/A',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['dispatchDate'] ?? 'N/A',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['manufacturingDate'] ?? 'N/A',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['batchNumber'] ?? 'N/A',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['dateOfWarranty'] ?? 'N/A',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['last_service'] ?? 'N/A',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
