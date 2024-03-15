// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'dart:io';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class DoctorDeviceAbout extends StatefulWidget {
  final String deviceId;
  final String deviceType;

  DoctorDeviceAbout(this.deviceId, this.deviceType);

  @override
  _DoctorDeviceAboutState createState() => _DoctorDeviceAboutState();
}

class _DoctorDeviceAboutState extends State<DoctorDeviceAbout> {
  
  Map<String, dynamic> deviceAbout = {};
  late String deviceId;
  late String deviceType;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
        Future.delayed(Duration(seconds: 3)).then((_) {
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    deviceId = widget.deviceId;
    deviceType = widget.deviceType;
    getProductionDetails();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    print('Saved Token: $mytoken');
    return mytoken;
  }

  Future<void> getProductionDetails() async {
    String? token = await getToken();
    if (token != null) {
      var response = await http.get(
        Uri.parse('$getProductionData/$deviceId'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        setState(() {
          deviceAbout = jsonResponse['data'];
          isLoading = false;
        });
      } else {
        print('Invalid User Credential: ${response.statusCode}');
      }
    } else {
      print('Token not found');
    }
  }

  void toggleFocus() async {
    String? token = await getToken();
    if (token != null) {
      var response = await http.put(
        Uri.parse('$addtofocus/$deviceId'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusCode'] == 200) {
        var data = jsonResponse['data'];
        print(data['addTofocus']);
        if (data['addTofocus'] == false) {}
      }
    } else {
      print("Token is null");
    }
  }

  @override
  dispose() {
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
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              "About",
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: getProductionDetails,
            child: OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return _buildPortraitLayout(context);
              } else {
                return _buildLandscapeLayout(context);
              }
            }),
          )),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.035,
        ),
        Text(
          widget.deviceType,
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: MediaQuery.of(context).size.width * 0.08,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        if (isLoading)
          SizedBox(
            height: 1,
            child: Center(child: LinearProgressIndicator(color: Colors.pink)),
          )
        else if (deviceAbout.isEmpty)
          Center(
            child: Text('No Data Found'),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Model :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Delivery Date :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Date of Manufacture :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Batch No :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Date of Warranty :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Last Service :',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _downloadPdf(deviceAbout['DhrPdf']);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                    ),
                    child: Text(
                      'Download DHR',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    deviceAbout['productType'] ?? '-',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['model'] ?? '-',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['dispatchDate'] ?? '-',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['manufacturingDate'] ?? '-',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['batchNumber'] ?? '-',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['dateOfWarranty'] ?? '-',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    deviceAbout['last_service'] ?? '-',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  void _downloadPdf(String? pdfUrl) async {
    if (pdfUrl != null) {
      var response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        Directory? downloadsDirectory = await getExternalStorageDirectory();
        String? downloadsPath = downloadsDirectory?.path;
        var time = DateTime.now().microsecondsSinceEpoch;
        var filePath = '$downloadsPath/DHR-$time.pdf';
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        _showDialog('Download Successful', 'File downloaded to: $filePath');
      } else {
        _showDialog('Download Failed', 'Please check your internet connection');
      }
    } else {
      print('PDF URL is null');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.035,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product :',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Model :',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Delivery Date :',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Date of Manufacture :',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Batch No :',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Date of Warranty :',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Last Service :',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  deviceAbout['productType'] ?? 'N/A',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  deviceAbout['model'] ?? 'N/A',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  deviceAbout['dispatchDate'] ?? 'N/A',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  deviceAbout['manufacturingDate'] ?? 'N/A',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  deviceAbout['batchNumber'] ?? 'N/A',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  deviceAbout['dateOfWarranty'] ?? 'N/A',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  deviceAbout['last_service'] ?? 'N/A',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
