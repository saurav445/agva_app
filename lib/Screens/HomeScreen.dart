// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_const, unused_import, library_private_types_in_public_api, prefer_typing_uninitialized_variables, unused_local_variable
import 'dart:convert';
import 'package:agva_app/AuthScreens/SignIn.dart';
import 'package:agva_app/Screens/DeviceDetails.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import '../widgets/ActiveDevices.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  HomeScreen(this.data);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String name;
  late String hospitalName;
  late String token;
  late SharedPreferences prefs;
  List<Map<String, dynamic>> deviceDataList = [];

  @override
  void initState() {
    super.initState();
    initSharedPref();
    name = widget.data['name'];
    hospitalName = widget.data['hospitalName'];
    token = widget.data['token'];
    // print('Frontend Response : Token: $token');
    fetchGetdevicesForUsers();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

    String deviceId = "deviceId";

  void fetchGetdevicesForUsers() async {
    var response = await http.get(
      Uri.parse(getDeviceForUser),
      headers: {
        "Authorization": 'Bearer $token',
      },
    );
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['statusValue'] == 'SUCCESS') {
      var data = jsonResponse['data'];
      var devicesList = data['data'];
      for (var deviceData in devicesList) {
        var deviceId = deviceData['deviceId'];
        var deviceInfoList = deviceData['deviceInfo'];
        print('deviceInfoList $deviceInfoList');
        print(deviceId);
         saveDeviceId(deviceId);
        setState(() {
          deviceDataList.add(deviceData);
        });
      }
    } else {
      print('Invalid User Credential: ${response.statusCode}');
    }
  }

    Future<void> saveDeviceId(String deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceId', deviceId);
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(5.0),
              //         child: Container(
              //           height: 60,
              //           width: 130,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.withOpacity(0.2),
              //                 spreadRadius: 1,
              //                 blurRadius: 10,
              //                 offset: Offset(0, 1),
              //               ),
              //             ],
              //             gradient: LinearGradient(
              //               begin: Alignment.topCenter,
              //               end: Alignment.bottomCenter,
              //               colors: [
              //                 Color.fromARGB(255, 157, 0, 86),
              //                 Color.fromARGB(255, 157, 0, 86)
              //               ],
              //             ),
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(left: 10, top: 5),
              //                 child: Text(
              //                   'Name',
              //                   style: TextStyle(
              //                     fontFamily: 'Avenir',
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //               Row(
              //                 children: [
              //                   Padding(
              //                     padding: EdgeInsets.only(left: 10),
              //                     child: Text(
              //                       '$name',
              //                       style: TextStyle(
              //                         fontFamily: 'Avenir',
              //                         fontSize: 15,
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.white,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //       Padding(
              //         padding: const EdgeInsets.all(5.0),
              //         child: Container(
              //           height: 60,
              //           width: 130,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.withOpacity(0.2),
              //                 spreadRadius: 1,
              //                 blurRadius: 10,
              //                 offset: Offset(0, 1),
              //               ),
              //             ],
              //             gradient: LinearGradient(
              //               begin: Alignment.topCenter,
              //               end: Alignment.bottomCenter,
              //               colors: [
              //                 Color.fromARGB(255, 157, 0, 86),
              //                 Color.fromARGB(255, 157, 0, 86)
              //               ],
              //             ),
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(left: 10, top: 5),
              //                 child: Text(
              //                   'Designation',
              //                   style: TextStyle(
              //                     fontFamily: 'Avenir',
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.only(left: 10),
              //                 child: Text(
              //                   'Not Specified',
              //                   style: TextStyle(
              //                     fontFamily: 'Avenir',
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //       Padding(
              //         padding: const EdgeInsets.all(5.0),
              //         child: Container(
              //           height: 60,
              //           width: 130,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.withOpacity(0.2),
              //                 spreadRadius: 1,
              //                 blurRadius: 10,
              //                 offset: Offset(0, 1),
              //               ),
              //             ],
              //             gradient: LinearGradient(
              //               begin: Alignment.topCenter,
              //               end: Alignment.bottomCenter,
              //               colors: [
              //                 Color.fromARGB(255, 157, 0, 86),
              //                 Color.fromARGB(255, 157, 0, 86)
              //               ],
              //             ),
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(left: 10, top: 5),
              //                 child: Text(
              //                   'Hospital',
              //                   style: TextStyle(
              //                     fontFamily: 'Avenir',
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.only(left: 10),
              //                 child: Text(
              //                   '$hospitalName',
              //                   style: TextStyle(
              //                     fontFamily: 'Avenir',
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //       Padding(
              //         padding: const EdgeInsets.all(5.0),
              //         child: Container(
              //           height: 60,
              //           width: 130,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.withOpacity(0.2),
              //                 spreadRadius: 1,
              //                 blurRadius: 10,
              //                 offset: Offset(0, 1),
              //               ),
              //             ],
              //             gradient: LinearGradient(
              //               begin: Alignment.topCenter,
              //               end: Alignment.bottomCenter,
              //               colors: [
              //                 Color.fromARGB(255, 157, 0, 86),
              //                 Color.fromARGB(255, 157, 0, 86)
              //               ],
              //             ),
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(left: 10, top: 5),
              //                 child: Text(
              //                   'Department',
              //                   style: TextStyle(
              //                     fontFamily: 'Avenir',
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.only(left: 10),
              //                 child: Text(
              //                   'Not Specified',
              //                   style: TextStyle(
              //                     fontFamily: 'Avenir',
              //                     fontSize: 15,
              //                     fontWeight: FontWeight.bold,
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: 10),
              //     ],
              //   ),
              // ),
              SizedBox(height: 10),
              if (deviceDataList.isNotEmpty) ActiveDevices(deviceDataList, []),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                // color: Colors.white,
              ),
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
              leading:
                  const Icon(Icons.home, color: Colors.white),
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
              leading:
                  const Icon(Icons.person, color: Colors.white),
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
