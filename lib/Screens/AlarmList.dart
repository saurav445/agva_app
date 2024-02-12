// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

class AlarmList extends StatefulWidget {
  @override
  AlarmListState createState() => AlarmListState();
}

class AlarmListState extends State<AlarmList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Focus Device',
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 24,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 65, 65, 65),
                  ),
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Color.fromARGB(255, 196, 128, 0),
                        ),
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'No O2 Suppply',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '02 FEB 24  05:55 PM',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                                     fontWeight: FontWeight.w200
                                  ),
                                ),
                                Text(
                                  'KMGU, Lucknow',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                            fontWeight: FontWeight.w200
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Ward No. 14',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                                     fontWeight: FontWeight.w200
                                  ),
                                ),
                                Text(
                                  'PT. Salim Raza',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                                     fontWeight: FontWeight.w200
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
