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
  Map<String, dynamic>? data;

  var mydeviceid = '724963b4f3ae2a8f';

  @override
  void initState() {
    super.initState();
    getProductionDetails();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  void getProductionDetails() async {
    String? token = await getToken();
    if (token != null) {
      // print(token);
      var response = await http.get(
        Uri.parse('$getProductionData/$mydeviceid'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        setState(() {
          data = jsonResponse['data'];
        });
        print('production data $data');
      } else {
        print('Invalid User Credential: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    getProductionDetails();
    return Container(
      decoration: BoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Text(
                    "About",
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 24,
                      color: Color.fromARGB(255, 157, 0, 86),
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
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
                                    color: Color.fromARGB(255, 58, 58, 58),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Model :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 58, 58, 58),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Delivery Date :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color:
                                        const Color.fromARGB(255, 65, 65, 65),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Date of Manufacture :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color:
                                        const Color.fromARGB(255, 65, 65, 65),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Batch No :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color:
                                        const Color.fromARGB(255, 65, 65, 65),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Date of Warranty :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color:
                                        const Color.fromARGB(255, 65, 65, 65),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Last Service :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color:
                                        const Color.fromARGB(255, 65, 65, 65),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data?['productType'],
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                       'AgVa-Pro',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                           color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                       data?['dispatchDate'],
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                       data?['manufacturingDate'],
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                       data?['batchNumber'],
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                       data?['dateOfWarranty'],
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                       'No Data Available',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
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
