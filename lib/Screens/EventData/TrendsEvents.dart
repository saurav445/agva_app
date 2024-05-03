// ignore_for_file: prefer__literals_to_create_immutables, prefer__ructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
              stringMap[key] = value.toString();
            });
            return stringMap;
          }),
        );
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
          trendData(trendsDataList: trendsDataList)
        else if (type == '003')
          trendDataForPatientMonitor(trendsDataList: trendsDataList),
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
class trendData extends StatelessWidget {
  trendData({
    super.key,
    required this.trendsDataList,
  });

  final List<Map<String, String>> trendsDataList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Column(
              children: [
                Container(
                  color: Color.fromARGB(255, 77, 77, 77),
                  height: 30,
                  width: 140,
                  child: Center(
                    child: Text(
                      'Parameter',
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
                      'Mode',
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
                      'PIP',
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
                      'PEEP',
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
                      'Mean Airway',
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
                      'VTi',
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
                      'VTe',
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
                      'MVe',
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
                      'MVi',
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
                      'FiO2',
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
                      'RR',
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
                      'I:E',
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
                      'Tinsp',
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: Color.fromARGB(255, 77, 77, 77),
                  height: 30,
                  width: 120,
                  child: Center(
                    child: Text(
                      'Unit',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'ModeType',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'cmH2O',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'cmH2O',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'cmH2O',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'ml',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'ml',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'Litre',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'Litre',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      '%',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'BPM',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'Ratio',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'sec',
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


// ignore: camel_case_types
class trendDataForPatientMonitor extends StatelessWidget {
  trendDataForPatientMonitor({
    super.key,
    required this.trendsDataList,
  });

  final List<Map<String, String>> trendsDataList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Column(
              children: [
                Container(
                  color: Color.fromARGB(255, 77, 77, 77),
                  height: 30,
                  width: 140,
                  child: Center(
                    child: Text(
                      'Parameter',
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
                      'Mode',
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
                      'PIP',
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
                      'PEEP',
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
                      'Mean Airway',
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
                      'VTi',
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
                      'VTe',
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
                      'MVe',
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
                      'MVi',
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
                      'FiO2',
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
                      'RR',
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
                      'I:E',
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
                      'Tinsp',
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
                      'Tinsp',
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
                      'Tinsp',
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
                      'Tinsp',
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: Color.fromARGB(255, 77, 77, 77),
                  height: 30,
                  width: 120,
                  child: Center(
                    child: Text(
                      'Time',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'ModeType',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'cmH2O',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'cmH2O',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'cmH2O',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'ml',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'ml',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'Litre',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'Litre',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      '%',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'BPM',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'Ratio',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'sec',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'sec',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ), Container(
                  color: Color.fromARGB(255, 218, 217, 217),
                  height: 25,
                  width: 120,
                  child: Center(
                    child: Text(
                      'sec',
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
                  width: 120,
                  child: Center(
                    child: Text(
                      'sec',
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
                          '${trendsData['spo2']}',
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
                          '${trendsData['pr']}',
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
                          '${trendsData['hr']}',
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
                          '${trendsData['ecgRR']}',
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
                          '${trendsData['iBP_S']}',
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
                          '${trendsData['iBP_D']}',
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
                          '${trendsData['cgm']}',
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
                          '${trendsData['etCo2']}',
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
                          '${trendsData['rr']}',
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
                          '${trendsData['nibp_S']}',
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
                          '${trendsData['nibp_D']}',
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
                          '${trendsData['temp1']}',
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
                          '${trendsData['temp2']}',
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
                          '${trendsData['iBP2_S']}',
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
                          '${trendsData['iBP2_D']}',
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