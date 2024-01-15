// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'dart:convert';
import 'package:agva_app/Screens/DeviceAbout.dart';
import 'package:agva_app/Screens/MonitorData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceDetails extends StatelessWidget {
  final Map<String, dynamic> deviceData;

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  DeviceDetails(this.deviceData);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Scaffold(
        // backgroundColor: Colors.grey,
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Text(
                    "Device Details",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DeviceID :',
                                  // 'deviceId',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                            color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Running Status :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                            color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Hours :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                                color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Total Hours :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                                color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Health :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                                color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Address :',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                                color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 70),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${deviceData['deviceId']}',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                              color: Color.fromARGB(255, 218, 218, 218),
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${deviceData['message']}',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                           color: Color.fromARGB(255, 0, 202, 10),
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${deviceData['last_hours']}',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                              color: Color.fromARGB(255, 218, 218, 218),
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${deviceData['total_hours']}',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                              color: Color.fromARGB(255, 218, 218, 218),
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${deviceData['health']}',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                              color: Color.fromARGB(255, 218, 218, 218),
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${deviceData['address']}',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                              color: Color.fromARGB(255, 218, 218, 218),
                                      fontSize: 16,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              height: 45,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(255, 255, 255, 255),
                                    Color.fromARGB(255, 255, 255, 255),
                                  ],
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(),
                                child: Text(
                                  "Live",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 157, 0, 86),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 45,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromARGB(255, 255, 255, 255),
                                    Color.fromARGB(255, 255, 255, 255),
                                  ],
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          // MonitorData(deviceData['deviceId']),
                                             MonitorData(deviceData),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(),
                                child: Text(
                                  "Monitor Data",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 157, 0, 86),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                            color: Colors.white,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 255, 255, 255),
                              ],
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeviceAbout(deviceData['deviceId']),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(),
                            child: Text(
                              "About",
                              style: TextStyle(
                                color: Color.fromARGB(255, 157, 0, 86),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          //   Positioned(
          //   top: 10,
          //   right: 10,
          //   child: FutureBuilder<String?>(
          //     future: getToken(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return CircularProgressIndicator();
          //       } else if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}');
          //       } else if (snapshot.hasData) {
          //         String? token = snapshot.data;
          //         return Text('Token: $token', style: TextStyle(fontSize: 16));
          //       } else {
          //         return Text('Token not found', style: TextStyle(fontSize: 16));
          //       }
          //     },
          //   ),
          // ),
          ],
        ),
      ),
    );
  }
}
