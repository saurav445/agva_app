// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DeviceDetails.dart';

class MyDevices extends StatefulWidget {
  @override
  _MyDevicesState createState() => _MyDevicesState();
}

class _MyDevicesState extends State<MyDevices> {
  List<String> focusedDevices = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> updateFocusList(String deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (focusedDevices.contains(deviceId)) {
        focusedDevices.remove(deviceId);
      } else {
        focusedDevices.add(deviceId);
      }
    });

    await prefs.setStringList('focusedDevices', focusedDevices);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       appBar: AppBar(
          centerTitle: true,
          title: Text(
            // widget.deviceId,
            ' ',
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 24,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            child: Column(
              children: [
                Text(
                  'My Devices',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                for (String deviceId in focusedDevices)
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DeviceDetails(deviceId),
                      //   ),
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 69, 174, 34),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 174, 34, 104),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 65, 65, 65),
                              ),
                              child: Text(
                                deviceId,
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
