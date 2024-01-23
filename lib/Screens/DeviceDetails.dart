// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'dart:convert';
import 'package:agva_app/Screens/DeviceAbout.dart';
import 'package:agva_app/Screens/MonitorData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceDetails extends StatefulWidget {
  late String deviceId;
  late String wardNo;
  late String deviceType;
  late String message;
  late String hospitalName;
  late String bioMed;
  late String departmentName;
  late String aliasName;

  DeviceDetails(this.deviceId, this.wardNo, this.deviceType, this.message,
      this.hospitalName, this.bioMed, this.departmentName, this.aliasName);

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                  Padding(
                    padding: const EdgeInsets.only(left: 45),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 40,
                            child: Image.asset("assets/images/back.png"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 75),
                          child: Column(
                            children: [
                              Text(
                                "Details",
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  Text(
                    "PT. SALIM RAZA",
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: 30,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(height: 30),

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WARD NO. ${widget.wardNo ?? "N/A"}',
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '65 KG',
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'BED NO. 115',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '25 YEARS',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //Live tiles
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 38, 128, 158),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         DeviceAbout(),
                                      //   ),
                                      // );
                                    },
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      "PC-SIMV",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 60,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 38, 128, 158),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'PIP',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'cmH2O',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '54',
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: Color.fromARGB(
                                                  255, 218, 218, 218),
                                              fontSize: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    height: 60,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 38, 128, 158),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'FiO2',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  '%',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '65',
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: Color.fromARGB(
                                                  255, 218, 218, 218),
                                              fontSize: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 60,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 38, 128, 158),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'RR',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'BPM',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '76',
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: Color.fromARGB(
                                                  255, 218, 218, 218),
                                              fontSize: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    height: 60,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 38, 128, 158),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'VTi',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'ml',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '52',
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: Color.fromARGB(
                                                  255, 218, 218, 218),
                                              fontSize: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 60,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 38, 128, 158),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'MVi',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'Liters',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '71',
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: Color.fromARGB(
                                                  255, 218, 218, 218),
                                              fontSize: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    height: 60,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 38, 128, 158),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'SpO2',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  '%',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '85',
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: Color.fromARGB(
                                                  255, 218, 218, 218),
                                              fontSize: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 60,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 38, 128, 158),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'PULSE',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'BPM',
                                                  style: TextStyle(
                                                    fontFamily: 'Avenir',
                                                    color: Color.fromARGB(
                                                        255, 218, 218, 218),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '75',
                                            style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: Color.fromARGB(
                                                  255, 218, 218, 218),
                                              fontSize: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 82, 82, 82),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DeviceAbout(
                                              widget.deviceId,
                                              widget.deviceType),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      "ABOUT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 60,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 82, 82, 82),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MonitorData(widget.deviceId, widget.wardNo, widget.message, widget.hospitalName, widget.bioMed, widget.departmentName, widget.aliasName),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      "MONITOR",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 82, 82, 82),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Container(
                                          width: 15,
                                          child: Image.asset(
                                            "assets/images/active.png",
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         MonitorData(deviceData),
                                          //   ),
                                          // );
                                        },
                                        style: TextButton.styleFrom(),
                                        child: Text(
                                          "LIVE VIEW",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 60,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 82, 82, 82),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         MonitorData(deviceData),
                                      //   ),
                                      // );
                                    },
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      "SUPPORT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 174, 34, 104),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Container(
                                  height: 60,
                                  width: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    color: Color.fromARGB(255, 82, 82, 82),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         MonitorData(deviceData),
                                      //   ),
                                      // );
                                    },
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      "ADD TO FOCUS",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
