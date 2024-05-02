// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:agva_app/Screens/Doctor&Assistant/DoctorDeviceList.dart';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DeviceListAgVaPro.dart';
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
  List<dynamic> productList = [];
  String? selectedHospital;

  @override
  void initState() {
    super.initState();
    getHospitals();
    getProductsList();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  void getProductsList() async {
    var response = await http.get(
      Uri.parse(getproductList),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(' data $jsonResponse');
      setState(() {
        productList = jsonResponse['data'];
        print('my product list $productList');
        // isLoading2 = false;
      });
    } else {
      print(' ${response.statusCode}');
      setState(() {
        // isLoading2 = false;
      });
    }
  }

  Future<void> getHospitals() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    if (mytoken != null) {
      var response = await http.get(Uri.parse(gethospitallist), headers: {
        "Authorization": 'Bearer $mytoken',
      });
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusCode'] == 200) {
        setState(() {
          hospitals = jsonResponse['data'];
          isLoading = false;
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
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: getHospitals,
        child: Stack(
          children: [
            if (isLoading)
              SizedBox(
                height: 1,
                child: LinearProgressIndicator(color: Colors.pink),
              )
            else if (hospitals.isEmpty)
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No Hospital List Found',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 158, 158, 158),
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Please Contact Doctor to Access List',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: buildPatientListWidgets(),
                    ),
                  ),
                ],
              ),
            if (productList.isNotEmpty && selectedHospital != null)
              ListView.builder(
                itemCount: productList.length,
                itemBuilder: (BuildContext context, int index) {
                  var product = productList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(255, 62, 62, 62),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              product['projectName'],
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 228, 228, 228),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                              child: Image.network(product['imageUrl']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildPatientListWidgets() {
    return hospitals.map((hospital) {
      String hospitalname = '${hospital['Hospital_Name']}';
      String city = '${hospital['City']}';
      String pincode = '${hospital['Pincode']}';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedHospital = hospitalname;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 51, 50, 50),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hospitalname,
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 1),
                            child: Row(
                              children: [
                                Text(
                                  '$city,',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                Text(
                                  pincode,
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Image.asset("assets/images/hospital.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      );
    }).toList();
  }
}
