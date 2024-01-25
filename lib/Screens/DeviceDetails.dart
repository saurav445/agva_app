// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'dart:convert';
import 'package:agva_app/Screens/DeviceAbout.dart';
import 'package:agva_app/Screens/MonitorData.dart';
import 'package:agva_app/widgets/Tiles.dart';
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
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Details",
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 24,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.035,
                ),
                Text(
                  "PT. SALIM RAZA",
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WARD NO. ${widget.wardNo}',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            '65 KG',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'BED NO. 115',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            '25 YEARS',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //Live tiles
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              width: MediaQuery.of(context).size.width * 0.42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 38, 128, 158),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(),
                                child: Text(
                                  "PC-SIMV",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            ResponsiveTileWidget(
                              title: 'FiO2',
                              value: '95',
                              unit: '%',
                              width: constraints.maxWidth * 0.42,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            ResponsiveTileWidget(
                              title: 'VTi',
                              value: '45',
                              unit: 'ml',
                              width: constraints.maxWidth * 0.42,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            ResponsiveTileWidget(
                              title: 'SpO2',
                              value: '125',
                              unit: '%',
                              width: constraints.maxWidth * 0.42,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ResponsiveTileWidget(
                              title: 'PIP',
                              value: '54',
                              unit: 'cmH2O',
                              width: constraints.maxWidth * 0.42,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            ResponsiveTileWidget(
                              title: 'RR',
                              value: '58',
                              unit: 'BPM',
                              width: constraints.maxWidth * 0.42,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            ResponsiveTileWidget(
                              title: 'MVi',
                              value: '69',
                              unit: 'Liters',
                              width: constraints.maxWidth * 0.42,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            ResponsiveTileWidget(
                              title: 'PULSE',
                              value: '47',
                              unit: 'BPM',
                              width: constraints.maxWidth * 0.42,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                //buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
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
                                          widget.deviceId, widget.deviceType),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(),
                                child: Text(
                                  "ABOUT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Expanded(
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 82, 82, 82),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MonitorData(
                                        widget.deviceId,
                                        widget.wardNo,
                                        widget.message,
                                        widget.hospitalName,
                                        widget.bioMed,
                                        widget.departmentName,
                                        widget.aliasName,
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(),
                                child: Text(
                                  "MONITOR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 82, 82, 82),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 15,
                                        child: Image.asset(
                                          "assets/images/active.png",
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(),
                                        child: Text(
                                          "LIVE VIEW",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.045,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          Expanded(
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 82, 82, 82),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(),
                                child: Text(
                                  "SUPPORT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(255, 174, 34, 104),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.065,
                            width: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              color: Color.fromARGB(255, 82, 82, 82),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(),
                              child: Text(
                                "ADD TO FOCUS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.045,
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
          ],
        ),
      ),
    );
  }
}
