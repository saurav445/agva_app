// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, library_private_types_in_public_api, use_key_in_widget_constructors
import 'dart:convert';
import 'package:agva_app/Screens/DeviceDetails.dart';
import 'package:agva_app/Service/SocketService.dart';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceList extends StatefulWidget {

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  bool isLoading = true;
  List<Map<String, dynamic>> devicesByHospitalList = [];
  List<Map<String, dynamic>> devicesForUserList = [];
  late String hospitalName;
  String? savedHospitalName;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    fetchGetDevicesForUser();
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

  Future<void> fetchGetDevicesForUser() async {
    setState(() {
      isLoading = true;
    });

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
        var data = jsonResponse['data'];
        devicesForUserList = List<Map<String, dynamic>>.from(data['data']);
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

  List<Widget> buildDeviceList() {
    return devicesForUserList.map((data) {
      Map<String, dynamic>? deviceInfo =
          (data['deviceInfo'] as List<dynamic>?)?.first;
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
                color: Color.fromARGB(255, 65, 65, 65),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 65, 65, 65),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${deviceInfo?['DeviceType'] ?? 'N/A'}',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Text(
                              '${deviceInfo?['Hospital_Name'] ?? 'N/A'}',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.005,
                            ),
                            Text(
                              'Ward: ${deviceInfo?['Ward_No'] ?? 'N/A'}',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'PT. Salim Raza',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Text(
                              '24 YEARS',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Text(
                              '58 KG',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
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
          if (devicesForUserList.isNotEmpty) {
            String deviceId = data['deviceId'];
            String message = data['message'];
            String wardNo = deviceInfo?['Ward_No'];
            String deviceType = deviceInfo?['DeviceType'];
            String hospitalName = deviceInfo?['Hospital_Name'];
            String departmentName = deviceInfo?['Department_Name'];
            String bioMed = deviceInfo?['Bio_Med'];
            String aliasName = deviceInfo?['Alias_Name'];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeviceDetails(
                    deviceId, SocketServices(), wardNo, deviceType, message),
              ),
            );
          }
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
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
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                    savedHospitalName ?? 'Default Hospital Name',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 218, 218, 218),
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                    'Hospital address',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 218, 218, 218),
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                // Devices List
                Column(
                  children: buildDeviceList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
