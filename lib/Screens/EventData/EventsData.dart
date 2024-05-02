// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Events extends StatefulWidget {
  final String deviceId;
  final String type;
  const Events(this.deviceId, this.type);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  bool isLoading = true;
  late String deviceId;
  late String type;
  late Map<String, dynamic> jsonResponse;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    type = widget.type;
    deviceId = widget.deviceId;
    checkAnLoad();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkAnLoad() {
    if (type.isEmpty) {
      getEventusingId(currentPage);
    } else {
      getEventusingId2(currentPage);
    }
  }

  Future<void> getEventusingId(currentPage) async {
    var response = await http.get(
      Uri.parse('$getDeviceEventbyID/$deviceId?page=$currentPage&limit=4'),
    );
    jsonResponse = jsonDecode(response.body);
    print('Current Device ID: $deviceId');
    if (jsonResponse['statusCode'] == 200) {
      print(jsonResponse);
      setState(() {
        isLoading = false;
      });
    } else {
      print('Invalid User Credential: ${response.statusCode}');
    }
  }

  Future<void> getEventusingId2(currentPage) async {
    var response = await http.get(
      Uri.parse('$getDeviceEventbyID2/$deviceId?page=$currentPage&limit=4'),
    );
    jsonResponse = jsonDecode(response.body);
    print('Current Device ID: $deviceId');
    if (jsonResponse['statusCode'] == 200) {
      print(jsonResponse);
      setState(() {
        isLoading = false;
      });
    } else {
      print('Invalid User Credential: ${response.statusCode}');
    }
  }

  void next() {
    {
      currentPage++;
      getEventusingId(currentPage);
    }
  }

  void back() {
    {
      currentPage--;
      getEventusingId(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 58, 58, 58),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildColumnHeading('Message'),
                buildColumnHeading('Type'),
                buildColumnHeading('Date'),
                buildColumnHeading('Time'),
              ],
            ),
          ),
          Container(
            height: 0.1,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          if (isLoading) // Show loading indicator
            buildEmptyContainer2()
          else if (jsonResponse['data']['findDeviceById']
              .isEmpty) // Show "No Alarm Logs" message
            buildEmptyContainer()
          else
            for (var eventData in jsonResponse['data']['findDeviceById'])
              buildEventDataRow(eventData, next, back),
        ],
      ),
      floatingActionButton: Container(
        // width: 150,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Color.fromARGB(0, 0, 0, 0)),

        child: Row(
          children: [
            if (currentPage >= 2)
              FloatingActionButton(
                backgroundColor: Colors.transparent,
                elevation: 1,
                onPressed: back,
                child: Icon(Icons.arrow_left_outlined),
              ),
            SizedBox(
              width: 10,
            ),
            if (currentPage >= 2) Text(currentPage.toString()),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 1,
              onPressed: next,
              child: Icon(Icons.arrow_right_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyContainer2() {
    return Padding(
        padding: const EdgeInsets.only(top: 80),
        child: CircularProgressIndicator());
  }

  Widget buildEmptyContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Text(
        'No Events Found',
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 218, 218, 218),
        ),
      ),
    );
  }

  Widget buildEventDataRow(Map<String, dynamic> eventData, next, back) {
    if (eventData.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 30,
                    ),
                    buildColumnContent(buildMsgContent(eventData['message'])),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    buildColumnContent(buildTypeContent(eventData['type'])),
                    buildColumnContent(buildDateContent(eventData['date'])),
                    buildColumnContent(buildTimeContent(eventData['time'])),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 60,
                ),
                Container(
                  height: 0.1,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return buildEmptyContainer();
    }
  }

  Widget builDeviceIdContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildMsgContent(String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5.2,
      child: Text(
        text,
        maxLines: 3,
        softWrap: true,
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 218, 218, 218),
        ),
      ),
    );
  }

  Widget buildTypeContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildDateContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildTimeContent(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }

  Widget buildColumnContent(Widget child) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          child,
        ],
      ),
    );
  }

  Widget buildColumnHeading(String heading) {
    return Text(
      heading,
      style: TextStyle(
        fontSize: 12,
        color: Color.fromARGB(255, 218, 218, 218),
      ),
    );
  }
}
