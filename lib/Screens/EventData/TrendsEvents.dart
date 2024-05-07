// ignore_for_file: prefer__literals_to_create_immutables, prefer__ructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hexcolor/hexcolor.dart';

class Trends extends StatefulWidget {
  final String deviceId;
  final String type;
  Trends(this.deviceId, this.type);

  @override
  State<Trends> createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  bool isLoading = true;
  late String deviceId;
  late String type;
  List<Map<String, String>> trendsDataList = [];
  List<dynamic> trendsSideData = [];

  @override
  void initState() {
    super.initState();
    getdeviceType();
    type = widget.type;
    deviceId = widget.deviceId;
    checkAnLoad();
  }

  void checkAnLoad() {
    if (type.isEmpty) {
      getTrendsbyId();
    } else {
      getTrendsbyId2();
    }
  }

  Future<void> getTrendsbyId() async {
    var response = await http.get(
      Uri.parse('$getDeviceTrendsbyID/$deviceId'),
    );
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['statusCode'] == 200) {
      print('this is my json response $jsonResponse');
      setState(() {
        isLoading = false;
        trendsDataList = List<Map<String, String>>.from(
          (jsonResponse['data']['findDeviceById'] as List<dynamic>)
              .map((dynamic item) {
            Map<String, String> stringMap = {};
            (item as Map<String, dynamic>).forEach((key, value) {
              stringMap[key] = value.toString();
            });
            return stringMap;
          }),
        );
        trendsSideData = jsonResponse['data2'];
      });
    } else {
      setState(() {
        isLoading = false;
        print(jsonResponse['message']);
      });
    }
  }

  Future<void> getTrendsbyId2() async {
    var response = await http.get(
      Uri.parse('$getDeviceTrendsbyID2/$deviceId'),
    );
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['statusCode'] == 200) {
      print('this is my json response $jsonResponse');
      setState(() {
        isLoading = false;
        trendsDataList = List<Map<String, String>>.from(
          (jsonResponse['data']['findDeviceById'] as List<dynamic>)
              .map((dynamic item) {
            Map<String, String> stringMap = {};
            (item as Map<String, dynamic>).forEach((key, value) {
              if (value is Map<String, dynamic>) {
                stringMap[key] = jsonEncode(value);
              } else {
                stringMap[key] = value.toString();
              }
            });
            return stringMap;
          }),
        );

        trendsSideData = jsonResponse['data2'];

        // trendsSideData = List<Map<String, String>>.from(
        //   (jsonResponse['data']['findDeviceById'] as List<dynamic>)
        //       .map((dynamic item) {
        //     Map<String, String> stringMap = {};
        //     (item as Map<String, dynamic>).forEach((key, value) {
        //       if (value is Map<String, dynamic>) {
        //         stringMap[key] = jsonEncode(value);
        //       } else {
        //         stringMap[key] = value.toString();
        //       }
        //     });
        //     return stringMap;
        //   }),
        // ); // There's an issue here
      });
    } else {
      setState(() {
        isLoading = false;
        print(jsonResponse['message']);
      });
    }
  }

  Future<String?> getdeviceType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? type = prefs.getString('type');
    print('Retrieved devieCode: $type');
    return type;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          buildEmptyContainer2()
        else if (trendsDataList.isEmpty)
          buildEmptyContainer()
        else if (type == '002')
          trendData(
              trendsDataList: trendsDataList, trendsSideData: trendsSideData)
        else if (type == '003')
          trendDataForPatientMonitor(
              trendsDataList: trendsDataList, trendsSideData: trendsSideData),
      ],
    );
  }

  Widget buildEmptyContainer2() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget buildEmptyContainer() {
    return Padding(
      padding: EdgeInsets.only(top: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Data Found',
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
}

// ignore: camel_case_types
class trendDataForPatientMonitor extends StatelessWidget {
  trendDataForPatientMonitor(
      {super.key, required this.trendsDataList, required this.trendsSideData});

  final List<Map<String, String>> trendsDataList;
  final List<dynamic> trendsSideData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: trendsSideData.map((sideData) {
            return Row(
              children: [
                Column(
                  children: [
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["Header Color"]}'),
                      height: 30,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["0"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["0"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["1"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["1"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["2"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["2"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["3"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["3"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["4"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["4"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["5"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["5"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["6"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["6"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["7"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["7"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["8"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["8"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["9"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["9"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["10"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["10"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["11"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["11"]}',
                              )),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["12"]}',
                          style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                '${sideData["colorCode"]["12"]}',
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["Header Color"]}'),
                      height: 30,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["0"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["0"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["1"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["1"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["2"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["2"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["3"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["3"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["4"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["4"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["5"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["5"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["6"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["6"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["7"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["7"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["8"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["8"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["9"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["9"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["10"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["10"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["11"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["11"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color:
                          HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["12"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: HexColor(
                              '${sideData["colorCode"]["12"]}',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }).toList(),
        ),
        // if (trendsDataList.isEmpty) buildEmptyContainer() else TrendsHeader(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: trendsDataList.map((trendsData) {
                return Column(
                  children: trendsSideData.map((sideData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          color: HexColor(
                            '${sideData["colorCode"]["Header Color"]}',
                          ),
                          height: 30,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['time']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["0"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG ODD Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['hr']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["1"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG EVEN Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['spo2']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["3"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG ODD Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['pr']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["4"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG EVEN Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['nibp_S']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["5"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG ODD Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['nibp_D']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["6"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG EVEN Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['etCo2']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["7"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG ODD Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['cgm']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["8"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG EVEN Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['etCo2']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["9"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG ODD Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['rr']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["10"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG EVEN Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['nibp_S']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["11"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG ODD Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['nibp_D']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["12"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: HexColor(
                              '${sideData["colorCode"]["BG EVEN Color"]}'),
                          height: 25,
                          width: 140,
                          child: Center(
                            child: Text(
                              '${trendsData['temp1']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                  '${sideData["colorCode"]["9"]}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        //     Container(
                        //  color:
                        //       HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                        //       height: 25,
                        //       width: 140,
                        //       child: Center(
                        //         child: Text(
                        //           '${trendsData['temp2']}',
                        //           style: TextStyle(
                        //             fontSize: 12,
                        //              color: HexColor(
                        //               '${sideData["colorCode"]["10"]}',
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //     color:
                        //       HexColor('${sideData["colorCode"]["BG EVEN Color"]}'),
                        //       height: 25,
                        //       width: 140,
                        //       child: Center(
                        //         child: Text(
                        //           '${trendsData['iBP2_S']}',
                        //           style: TextStyle(
                        //             fontSize: 12,
                        //              color: HexColor(
                        //               '${sideData["colorCode"]["11"]}',
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //    color:
                        //       HexColor('${sideData["colorCode"]["BG ODD Color"]}'),
                        //       height: 25,
                        //       width: 140,
                        //       child: Center(
                        //         child: Text(
                        //           '${trendsData['iBP2_D']}',
                        //           style: TextStyle(
                        //             fontSize: 12,
                        //              color: HexColor(
                        //               '${sideData["colorCode"]["12"]}',
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                      ],
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class trendData extends StatelessWidget {
  trendData(
      {super.key, required this.trendsDataList, required this.trendsSideData});

  final List<Map<String, String>> trendsDataList;
  final List<dynamic> trendsSideData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: trendsSideData.map((sideData) {
            return Row(
              children: [
                Column(
                  children: [
                    Container(
                      color: HexColor('${sideData["colorCode"]["0"]}'),
                      height: 30,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["0"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: HexColor('${sideData["colorCode"]["0"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["1"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: HexColor('${sideData["colorCode"]["0"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["2"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["3"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["4"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["5"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["6"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["7"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["8"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["9"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["10"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["11"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["Mode"]["12"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Color.fromARGB(255, 77, 77, 77),
                      height: 30,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["0"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["1"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["2"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["3"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["4"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["5"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["6"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["7"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["8"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["9"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: HexColor('${sideData["colorCode"]["0"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["10"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: HexColor('${sideData["colorCode"]["0"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["11"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: HexColor('${sideData["colorCode"]["0"]}'),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${sideData["ModeType"]["12"]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }).toList(),
        ),
        // if (trendsDataList.isEmpty) buildEmptyContainer() else TrendsHeader(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: trendsDataList.map((trendsData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: Color.fromARGB(255, 77, 77, 77),
                      height: 30,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['time']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['mode']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['pip']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['peep']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['mean_Airway']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['vti']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['vte']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['mve']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['mvi']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['fio2']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['respiratory_Rate']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 161, 161, 161),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['ie']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color.fromARGB(255, 218, 217, 217),
                      height: 25,
                      width: 140,
                      child: Center(
                        child: Text(
                          '${trendsData['tinsp']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
