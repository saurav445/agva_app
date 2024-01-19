// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:convert';
import 'package:agva_app/Screens/DeviceDetails.dart';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceList extends StatefulWidget {
  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  List<Map<String, dynamic>> devicesList = [];
  late String hospitalName;
  String? savedHospitalName;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    fetchGetdevicesForUsers();
    getDevicesByHospitalName();
    gethospital().then((name) {
      setState(() {
        savedHospitalName = name;
      });
    });
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  Future<String?> gethospital() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hospitalName = prefs.getString('hospitalName');
    print('Retrieved hospital name: $hospitalName');
    return hospitalName;
  }

  void getDevicesByHospitalName() async {
    String? token = await getToken();
    String? hospitalName = await gethospital();
    if (token != null) {
      var response = await http.get(
        Uri.parse('$getDevicesByHospital/${hospitalName}'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        //  print('Device by Hospital: $jsonResponse');
        devicesList = List<Map<String, dynamic>>.from(jsonResponse['data']);
        setState(() {});
      } else {
        print('Invalid User Credential: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  void fetchGetdevicesForUsers() async {
    String? token = await getToken();
    if (token != null) {
      var response = await http.get(
        Uri.parse(getDeviceForUser),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        // print('Device by User: $jsonResponse');
        var data = jsonResponse['data'];
        var devicesList = data['data'];
        for (var deviceData in devicesList) {
          var mydeviceId = deviceData['deviceId'];
          // print(mydeviceId);
          // saveDeviceId(mydeviceId);

          List<Map<String, dynamic>> fetchedDevices =
              List<Map<String, dynamic>>.from(jsonResponse['data']['data']);

          setState(() {
            devicesList = fetchedDevices;
          });
        }
      } else {
        print('Invalid User Credential: ${response.statusCode}');
      }
    }
  }

  List<Widget> buildDeviceList() {
    return devicesList.map((device) {
      Map<String, dynamic>? deviceInfo =
          (device['deviceInfo'] as List<dynamic>?)?.first;
      return ListTile(
        title: Container(
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
                  height: 110,
                  width: 330,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 65, 65, 65),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              device['deviceId'],
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              savedHospitalName ?? 'Default Hospital Name',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              // 'Ward',
                              'Ward: ${deviceInfo?['Ward_No'] ?? 'N/A'}',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'N/A',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'N/A',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'N/A',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize: 16,
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeviceDetails(),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                savedHospitalName ?? 'Default Hospital Name',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  color: Color.fromARGB(255, 218, 218, 218),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Hospital address',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  color: Color.fromARGB(255, 218, 218, 218),
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            // Devices List
            Column(
              children: buildDeviceList(),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'AgVa',
                  style: TextStyle(
                    color: Color.fromARGB(255, 157, 0, 86),
                    fontSize: 50,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: Text(
                'HOME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: Text(
                'PROFILE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.devices_other, color: Colors.white),
              title: Text(
                'DEVICES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.white),
              title: Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: Text(
                'SETTINGS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
