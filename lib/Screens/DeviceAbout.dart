// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceAbout extends StatelessWidget {
  final String deviceId;

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  DeviceAbout(this.deviceId);

  var mydeviceid = '724963b4f3ae2a8f';
  
void getProductionDetails() async {
  String? token = await getToken(); 
  if (token != null) {
    print(token);
    var response = await http.get(
      Uri.parse('$getProductionData/$mydeviceid'),
      headers: {
        "Authorization": 'Bearer $token',
      },
    );
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    if (jsonResponse['statusValue'] == 'SUCCESS') {
      var data = jsonResponse['data'];
      print('production data $data');
      // print('production data $deviceId');
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
          // alignment: Alignment.center,
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
                                  //  deviceId,
                                  //  data['productType'],
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
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    deviceId,
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '--',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 46, 105, 7),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '--',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '--',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '--',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '--',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Color.fromARGB(255, 58, 58, 58),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '--',
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
