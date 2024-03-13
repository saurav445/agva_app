// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Trends extends StatefulWidget {
  final String deviceId;
  const Trends(this.deviceId);

  @override
  State<Trends> createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  bool isLoading = true;
  late String deviceId;
  List<Map<String, String>> trendsDataList = [];

  @override
  void initState() {
    super.initState();
    deviceId = widget.deviceId;
    getTrendsbyId();
  }

  Future<void> getTrendsbyId() async {
    var response = await http.get(
      Uri.parse('$getDeviceTrendsbyID/$deviceId'),
    );
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['statusCode'] == 200) {
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
      print('Invalid User Credential: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading) 
          buildEmptyContainer2()
        else if (trendsDataList.isEmpty) 
          buildEmptyContainer()
        else
          trendData(trendsDataList: trendsDataList),
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
      padding: const EdgeInsets.only(top: 80),
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
  const trendData({
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: Color.fromARGB(255, 77, 77, 77),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 39, vertical: 6),
                    child: Text(
                      'Parameter',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Mode',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 58, vertical: 3),
                    child: Text(
                      'PIP',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'PEEP',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 3),
                    child: Text(
                      'Mean Airway',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'VTi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 57, vertical: 3),
                    child: Text(
                      'VTe',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'MVe',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 57, vertical: 3),
                    child: Text(
                      'MVi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'FiO2',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 60, vertical: 3),
                    child: Text(
                      'RR',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'I:E',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 52, vertical: 3),
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 39, vertical: 6),
                    child: Text(
                      'Unit',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'ModeType',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    child: Text(
                      'cmH2O',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'cmH2O',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    child: Text(
                      'cmH2O',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'ml',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 43.5, vertical: 3),
                    child: Text(
                      'ml',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Litre',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 38, vertical: 3),
                    child: Text(
                      'Litre',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    '%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 38, vertical: 3),
                    child: Text(
                      'BPM',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Ratio',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 218, 218, 218),
                    ),
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 218, 217, 217),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 41, vertical: 3),
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
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 39.5, vertical: 6),
                        child: Text(
                          '${trendsData['time']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                    Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '${trendsData['mode']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 218, 218, 218),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 218, 217, 217),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 3),
                        child: Text(
                          '${trendsData['pip']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '${trendsData['peep']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 218, 218, 218),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 218, 217, 217),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 3),
                        child: Text(
                          '${trendsData['mean_Airway']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '${trendsData['vti']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 218, 218, 218),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 218, 217, 217),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 44.5, vertical: 3),
                        child: Text(
                          '${trendsData['vte']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '${trendsData['mve']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 218, 218, 218),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 218, 217, 217),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 46, vertical: 3),
                        child: Text(
                          '${trendsData['mvi']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                       padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '${trendsData['fio2']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 218, 218, 218),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 218, 217, 217),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 3),
                        child: Text(
                          '${trendsData['respiratory_Rate']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                 padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '${trendsData['ie']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 218, 218, 218),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(255, 218, 217, 217),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 46, vertical: 3),
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
