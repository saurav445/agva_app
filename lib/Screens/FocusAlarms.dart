// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:convert';
import 'package:agva_app/Screens/AlarmList.dart';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FocusAlarms extends StatefulWidget {
  @override
  FocusAlarmsState createState() => FocusAlarmsState();
}

class FocusAlarmsState extends State<FocusAlarms> {
  List<Map<String, dynamic>> focusedDevices = [];
  List<Map<String, dynamic>> devicesForUserList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFocusedDevices();
  }

  Future<void> fetchFocusedDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    if (mytoken != null) {
      var response = await http.get(
        Uri.parse(getFocusDevices),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var data = jsonResponse['data']['data'];
        print(data);
        setState(() {
          isLoading = false;
          focusedDevices = List<Map<String, dynamic>>.from(data)
              .where((device) => device['addTofocus'] == true)
              .toList();
        });
      } else {
        print('Failed to fetch focused devices: ${response.statusCode}');
      }
    } else {
      print("Token is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              '',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return SingleChildScrollView(
                child: FocusDevicesPortrait(
                  focusedDevices: focusedDevices,
                  isLoading: isLoading,
                ),
              );
            } else {
              return SingleChildScrollView(
                child: FocusDevicesLandscape(
                  focusedDevices: focusedDevices,
                  isLoading: isLoading,
                ),
              );
            }
          })),
    );
  }
}

class FocusDevicesLandscape extends StatelessWidget {
  late bool isLoading;
  FocusDevicesLandscape(
      {super.key, required this.focusedDevices, required this.isLoading});

  final List<Map<String, dynamic>> focusedDevices;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          SizedBox(
              height: 1, child: LinearProgressIndicator(color: Colors.pink))
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  for (var device in focusedDevices)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlarmList(
                                  device['deviceInfo']?[0]?['DeviceId'],
                                  device['deviceInfo']?[0]?['Hospital_Name']),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: Color.fromARGB(255, 69, 174, 34),
                            color: Color.fromARGB(255, 65, 65, 65),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 174, 34, 104)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 65, 65, 65),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 11, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${device['deviceInfo']?[0]?['DeviceType']}',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.015,
                                            ),
                                            Text(
                                              '${device['deviceInfo']?[0]?['Hospital_Name']}',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.005,
                                            ),
                                            Text(
                                              'Ward No. ${device['deviceInfo']?[0]?['Ward_No']}',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'PT. Salim Raza',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.015,
                                            ),
                                            Text(
                                              '24 YEARS',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.005,
                                            ),
                                            Text(
                                              '58 KG',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class FocusDevicesPortrait extends StatelessWidget {
  late bool isLoading;
  FocusDevicesPortrait(
      {super.key, required this.focusedDevices, required this.isLoading});

  final List<Map<String, dynamic>> focusedDevices;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          SizedBox(
              height: 1, child: LinearProgressIndicator(color: Colors.pink))
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  for (var device in focusedDevices)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlarmList(
                                  device['deviceInfo']?[0]?['DeviceId'],
                                  device['deviceInfo']?[0]?['Hospital_Name']),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: Color.fromARGB(255, 69, 174, 34),
                            color: Color.fromARGB(255, 65, 65, 65),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 174, 34, 104)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 65, 65, 65),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 11, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${device['deviceInfo']?[0]?['DeviceType']}',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            Text(
                                              '${device['deviceInfo']?[0]?['Hospital_Name']}',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.005,
                                            ),
                                            Text(
                                              'Ward No. ${device['deviceInfo']?[0]?['Ward_No']}',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'PT. Salim Raza',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            Text(
                                              '24 YEARS',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            Text(
                                              '58 KG',
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
