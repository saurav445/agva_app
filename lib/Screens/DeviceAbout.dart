// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceAbout extends StatefulWidget {
  final String deviceId;

  DeviceAbout(this.deviceId);

  @override
  _DeviceAboutState createState() => _DeviceAboutState();
}

class _DeviceAboutState extends State<DeviceAbout> {
  Map<String, dynamic> deviceAbout = {};
  late String deviceId;

  @override
  void initState() {
    super.initState();
    deviceId = widget.deviceId;
    getProductionDetails();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    print('Saved Token: $mytoken');
    return mytoken;
  }

  // var did = '724963b4f3ae2a8f';

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
    return Container(
      decoration: BoxDecoration(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Text(
                    "N/A",
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
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                SizedBox(height: 30),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    deviceAbout['productType']  ?? 'N/A',
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
                                    deviceAbout['dispatchDate']  ?? 'N/A',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    deviceAbout['manufacturingDate']  ?? 'N/A',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    deviceAbout['batchNumber']  ?? 'N/A',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    deviceAbout['dateOfWarranty']  ?? 'N/A',
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
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
