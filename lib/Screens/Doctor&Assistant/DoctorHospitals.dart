// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DoctorDeviceList.dart';
import 'package:http/http.dart' as http;

class DoctorHospitals extends StatefulWidget {
  DoctorHospitals();

  @override
  _DoctorHospitalsState createState() => _DoctorHospitalsState();
}

class _DoctorHospitalsState extends State<DoctorHospitals> {
  late SharedPreferences prefs;
  bool isLoading = true;
  List<dynamic> hospitals = [];
  Map<String, bool> expansionStates = {};

  @override
  void initState() {
    super.initState();
    getHospitals();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  List<String> projectsForHospital = [
    'AgVa PRO',
    'Emergency',
  ];

  Future<void> getHospitals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    if (mytoken != null) {
      var response = await http.get(Uri.parse(gethospitallist), headers: {
        "Authorization": 'Bearer $mytoken',
      });
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusCode'] == 200) {
        setState(() {
          hospitals = jsonResponse['data'];

          hospitals.forEach((hospital) {
            expansionStates[hospital['Hospital_Name']] = false;
            isLoading = false;
          });
        });
      } else {
        print('Invalid User Credential : ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'HOSPITALS',
          style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: 24,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getHospitals,
        child: Stack(children: [
          ListView(children: [
            Column(
              children: buildPatientListWidgets(),
            ),
          ]),
        ]),
      ),
    );
  }

  List<Widget> buildPatientListWidgets() {
    return hospitals.map((hospital) {
      String hospitalname = '${hospital['Hospital_Name']}';
      String city = '${hospital['City']}';
      String pincode = '${hospital['Pincode']}';
      String hospitaladdress = '${hospital['Hospital_Address']}';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                expansionStates[hospitalname] = !expansionStates[hospitalname]!;
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.13,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color.fromARGB(255, 51, 50, 50),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hospitalname,
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Row(
                            children: [
                              Text(
                                '$city,',
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  color: Color.fromARGB(255, 218, 218, 218),
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                pincode,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Image.asset("assets/images/hospital.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          if (expansionStates[hospitalname]!)
            ...projectsForHospital.map(
              (project) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    if (project == 'AgVa PRO') {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DoctorDeviceList(hospitalname, hospitaladdress),
                        ),
                      );
                      if (result != null && result == 'refresh') {
                        getHospitals();
                      }
                    } else {
                      final snackBar = SnackBar(
                        backgroundColor: const Color.fromARGB(255, 65, 65, 65),
                        content: Text(
                          "Not Available",
                          style: TextStyle(color: Colors.white),
                        ),
                        action: SnackBarAction(
                          textColor: Colors.black,
                          backgroundColor: Colors.white,
                          label: 'OK',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(255, 62, 62, 62),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            project,
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 228, 228, 228),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Image.asset(
                              getImagePath(project),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.010,
          ),
        ],
      );
    }).toList();
  }

  String getImagePath(project) {
    switch (project) {
      case 'AgVa PRO':
        return "assets/images/deviceimage.png";
      case 'Emergency':
        return "assets/images/deviceimage.png";
      default:
        return "assets/images/inactive.png";
    }
  }
}
