// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:agva_app/Screens/Doctor&Assistant/DeviceDetailsAgVaPro.dart';
import 'package:agva_app/Service/SocketService.dart';
import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DoctorMyDevices extends StatefulWidget {
  @override
  _DoctorMyDevicesState createState() => _DoctorMyDevicesState();
}

class _DoctorMyDevicesState extends State<DoctorMyDevices> {
  List<Map<String, dynamic>> focusedDevices = [];
  List<Map<String, dynamic>> focusedDevices2 = [];
  bool isLoading = true;
  Color? newColor;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    print('here  i am ');
    fetchFocusedDevices();
    fetchFocusedDevices2();
  }

  Future<void> fetchFocusedDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');

    if (mytoken != null) {
      var response = await http.get(
        Uri.parse(getAllFocusDevice),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var data = jsonResponse['data']['data'];
        print(' my data $data');
        setState(() {
          print(focusedDevices);
          focusedDevices = List<Map<String, dynamic>>.from(data)
              .where((device) => device['addTofocus'] == true)
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to fetch focused devices: ${response.statusCode}');
      }
    } else {
      print("Token is null");
    }
  }

  Future<void> fetchFocusedDevices2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');

    if (mytoken != null) {
      var response = await http.get(
        Uri.parse(getDeviceForDoctor),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var data = jsonResponse['data']['data'];
        print(' my data $data');
        setState(() {
          focusedDevices2 = List<Map<String, dynamic>>.from(data)
              .where((device) => device['addTofocus'] == true)
              .toList();
          isLoading = false;
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'My Devices',
            style: TextStyle(
              fontFamily: 'Avenir',
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: fetchFocusedDevices,
          child: Stack(
           children: [ 
              if (isLoading)
             SizedBox(
                 height: 1,
                 child: LinearProgressIndicator(color: Colors.pink))
           else if (focusedDevices.isEmpty && focusedDevices2.isEmpty)
             SizedBox(
               width: double.infinity,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Text(
                     'No Focused Devices Found',
                     style: TextStyle(
                       fontFamily: 'Avenir',
                       color: Color.fromARGB(255, 158, 158, 158),
                       fontSize: MediaQuery.of(context).size.width * 0.04,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   Text(
                     'Please Add Device to Focus',
                     style: TextStyle(
                       fontFamily: 'Avenir',
                       color: Color.fromARGB(255, 218, 218, 218),
                       fontSize: MediaQuery.of(context).size.width * 0.04,
                       fontWeight: FontWeight.w100,
                     ),
                   ),
                 ],
               ),
             )
           else
             
           ListView(
      children: [
        Column(
          children: [
              for (var device in focusedDevices2)
                Builder(builder: (context) {
 
                  var newColor;
                  if (device['addTofocus'] == true) {
                    newColor = Color.fromARGB(255, 174, 34, 104);
                  } else {
                    newColor =
                        Color.fromARGB(255, 58, 58, 58); // Or any default color
                  }

                  Color? alarmColor;
                  if (device['alarmData']?.isNotEmpty ?? false) {
                    String priority = device['alarmData'][0]['priority'];

                    if (priority == 'ALARM_LOW_LEVEL') {
                      alarmColor = Colors.amber;
                    } else if (priority == 'ALARM_MEDIUM_LEVEL') {
                      alarmColor = Colors.amber;
                    } else if (priority == 'ALARM_HIGH_LEVEL') {
                      alarmColor = Colors.red;
                    } else if (priority == 'ALARM_CRITICAL_LEVEL') {
                      alarmColor = Colors.red;
                    }
                  } else {
                    alarmColor = Colors.green;
                  }

                  String? ptName;
                  String? ptAge;
                  String? ptWeight;
                  if (device['patientData']?.isNotEmpty ?? false) {
                    if (device['patientData'][0]['patientName'].isNotEmpty) {
                      ptName = 'PT. ${device['patientData'][0]['patientName']}';
                    } else {
                      ptName = '-';
                    }
                    if (device['patientData'][0]['age'].isNotEmpty) {
                      ptAge = '${device['patientData'][0]['age']} YEARS';
                    } else {
                      ptAge = '-';
                    }
                    if (device['patientData'][0]['weight'].isNotEmpty) {
                      ptWeight = '${device['patientData'][0]['weight']} KG';
                    } else {
                      ptWeight = '-';
                    }
                  } else {
                    ptName = '-';
                    ptAge = '-';
                    ptWeight = '-';
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeviceDetailsAgVaPro(
                                    device['deviceInfo']?[0]['DeviceId'],
                                    SocketServices(),
                                    device['deviceInfo']?[0]['Ward_No'],
                                    device['deviceInfo']?[0]['DeviceType'],
                                    device['message'],
                                  ),
                                ),
                              );

                              if (result != null && result == 'refresh') {
                                fetchFocusedDevices();
                                fetchFocusedDevices2();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: alarmColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: newColor),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 58, 58, 58),
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                  ptName,
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                  ptAge,
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                  ptWeight,
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                  );
                }),
          ],
        ),
        Column(
          children: [
              for (var device in focusedDevices)
                Builder(builder: (context) {
                  print('Alarm Data : ${device['alarmData']}');
                  print('Patient Data : ${device['patientData']}');
                  var newColor;
                  if (device['addTofocus'] == true) {
                    newColor = Color.fromARGB(255, 174, 34, 104);
                  } else {
                    newColor =
                        Color.fromARGB(255, 58, 58, 58); // Or any default color
                  }

                  Color? alarmColor;
                  if (device['alarmData']?.isNotEmpty ?? false) {
                    String priority = device['alarmData'][0]['priority'];

                    if (priority == 'ALARM_LOW_LEVEL') {
                      alarmColor = Colors.amber;
                    } else if (priority == 'ALARM_MEDIUM_LEVEL') {
                      alarmColor = Colors.amber;
                    } else if (priority == 'ALARM_HIGH_LEVEL') {
                      alarmColor = Colors.red;
                    } else if (priority == 'ALARM_CRITICAL_LEVEL') {
                      alarmColor = Colors.red;
                    }
                  } else {
                    alarmColor = Colors.green;
                  }

                  String? ptName;
                  String? ptAge;
                  String? ptWeight;
                  if (device['patientData']?.isNotEmpty ?? false) {
                    if (device['patientData'][0]['patientName'].isNotEmpty) {
                      ptName = 'PT. ${device['patientData'][0]['patientName']}';
                    } else {
                      ptName = '-';
                    }
                    if (device['patientData'][0]['age'].isNotEmpty) {
                      ptAge = '${device['patientData'][0]['age']} YEARS';
                    } else {
                      ptAge = '-';
                    }
                    if (device['patientData'][0]['weight'].isNotEmpty) {
                      ptWeight = '${device['patientData'][0]['weight']} KG';
                    } else {
                      ptWeight = '-';
                    }
                  } else {
                    ptName = '-';
                    ptAge = '-';
                    ptWeight = '-';
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeviceDetailsAgVaPro(
                                    device['deviceInfo']?[0]['DeviceId'],
                                    SocketServices(),
                                    device['deviceInfo']?[0]['Ward_No'],
                                    device['deviceInfo']?[0]['DeviceType'],
                                    device['message'],
                                  ),
                                ),
                              );

                              if (result != null && result == 'refresh') {
                                  fetchFocusedDevices();
                                fetchFocusedDevices2();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: alarmColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: newColor),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 58, 58, 58),
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                  ptName,
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                  ptAge,
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                  ptWeight,
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                  );
                }),
          ],
        ),
      ],
      
    ),
                      
           ],
          ),
        ),
      ),
    );
  }
}
