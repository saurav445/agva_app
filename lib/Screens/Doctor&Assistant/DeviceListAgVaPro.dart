// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, must_be_immutable
import 'dart:convert';
import 'package:agva_app/Screens/Doctor&Assistant/DeviceDetailsAgVaPro.dart';
import 'package:agva_app/Service/SocketService.dart';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceListAgVaPro extends StatefulWidget {
  final String hospitalName;
  final String hospitaladdress;
  DeviceListAgVaPro(this.hospitalName, this.hospitaladdress);

  @override
  _DeviceListAgVaProState createState() => _DeviceListAgVaProState();
}

class _DeviceListAgVaProState extends State<DeviceListAgVaPro> {
  bool isLoading = true;
  late String hospitalName;
  late String hospitaladdress;
  List<Map<String, dynamic>> focusedDevices = [];
  bool requestdata = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    print(widget.hospitalName);
    print('i am in device list');
    fetchGetDevicesForDoctor();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  Future<void> fetchGetDevicesForDoctor() async {
    setState(() {
      isLoading = true;
    });

    String? token = await getToken();
    if (token != null) {
      var response = await http.get(
        Uri.parse(getDeviceForDoctor),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        var data = jsonResponse['data']['data'];
        print(jsonResponse);
        // devicesForUserList = List<Map<String, dynamic>>.from(data['data']);
        focusedDevices = List<Map<String, dynamic>>.from(data)
            .where((device) =>
                device['isAssigned'] == true &&
                device['deviceInfo'][0]?['Hospital_Name'] ==
                    widget.hospitalName)
            .toList();

        setState(() {
          isLoading = false;
        });
      } else {
        print('Invalid User Credential: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, 'refresh');
            },
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            ' ',
            style: TextStyle(
              fontFamily: 'Avenir',
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: RefreshIndicator(
          color: Color.fromARGB(255, 174, 34, 104),
          onRefresh: fetchGetDevicesForDoctor,
          child: Stack(
            children: [
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Text(
                      widget.hospitalName,
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Text(
                      widget.hospitaladdress,
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      if (isLoading)
                        SizedBox(
                            height: 1,
                            child: LinearProgressIndicator(
                                color: Color.fromARGB(255, 174, 34, 104)))
                      else if (focusedDevices.isEmpty)
                        Column(
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height / 3),
                            Text('No Devices'),
                          ],
                        )
                      else
                        for (var device in focusedDevices)
                          Builder(builder: (context) {
                        
                         
                            var newColor;
                            if (device['addTofocus'] == true) {
                              newColor = Color.fromARGB(255, 174, 34, 104);
                            } else {
                              newColor = Color.fromARGB(
                                  255, 58, 58, 58); // Or any default color
                            }

                            Color? alarmColor;
                            if (device['alarmData']?.isNotEmpty ?? false) {
                              String priority =
                                  device['alarmData'][0]['priority'];

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
                            if (device['patientData'].isNotEmpty) {
                              if (device['patientData'][0]['patientName']
                                  .isNotEmpty) {
                                ptName =
                                    'PT. ${device['patientData'][0]['patientName']}';
                              } else {
                                ptName = '-';
                              }
                              if (device['patientData'][0]['age'].isNotEmpty) {
                                ptAge = '${device['patientData'][0]['age']} YEARS';
                              } else {
                                ptAge = '-';
                              }
                              if (device['patientData'][0]['weight']
                                  .isNotEmpty) {
                                ptWeight =
                                    '${device['patientData'][0]['weight']} KG';
                              } else {
                                ptWeight = '-';
                              }
                            } else {
                              ptName = '-';
                              ptAge = '-';
                              ptWeight = '-';
                            }

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DeviceDetailsAgVaPro(
                                              device['deviceInfo']?[0]
                                                  ['DeviceId'],
                                              SocketServices(),
                                              device['deviceInfo']?[0]
                                                  ['Ward_No'],
                                              device['deviceInfo']?[0]
                                                  ['deviceType'],
                                              device['message'],

                                              
                                            ),
                                          ),
                                        );

                                        if (result != null &&
                                            result == 'refresh') {
                                          fetchGetDevicesForDoctor();
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: alarmColor,
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: newColor),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 58, 58, 58),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 11,
                                                      vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${device['deviceInfo']?[0]?['deviceType']}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Avenir',
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      218,
                                                                      218,
                                                                      218),
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.05,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.01,
                                                          ),
                                                          Text(
                                                            '${device['deviceInfo']?[0]?['Hospital_Name']}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Avenir',
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      218,
                                                                      218,
                                                                      218),
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.03,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.005,
                                                          ),
                                                          Text(
                                                            'Ward No. ${device['deviceInfo']?[0]?['Ward_No']}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Avenir',
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      218,
                                                                      218,
                                                                      218),
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.03,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            ptName,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Avenir',
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      218,
                                                                      218,
                                                                      218),
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            ptAge,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Avenir',
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      218,
                                                                      218,
                                                                      218),
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.03,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.01,
                                                          ),
                                                          Text(
                                                            ptWeight,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Avenir',
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      218,
                                                                      218,
                                                                      218),
                                                              fontSize: MediaQuery.of(
                                                                          context)
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
