// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable
import 'package:agva_app/Screens/Doctor&Assistant/AddPatientData.dart';
import 'package:agva_app/Screens/Doctor&Assistant/DosageHistory.dart';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PatientList extends StatefulWidget {
  final String deviceId;
  const PatientList(this.deviceId);

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList>
    with SingleTickerProviderStateMixin {
  late String deviceId;
  List<dynamic> userData = [];
  List<dynamic> currentData = [];
  bool isLoading = true;
  late TabController _tabController;
  String updateUser = 'Current';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    getPatientData();
  }

  void _handleTabSelection() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          updateUser = 'Current';
          getPatientData();
          break;
        case 1:
          updateUser = 'Past';
          getPatientData();
          break;
      }
    });
  }

  void getPatientData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    if (mytoken != null) {
      var response = await http.get(
        Uri.parse('$patientList/${widget.deviceId}'),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusCode'] == 200) {
        setState(() {
          userData = jsonResponse['data'];
          currentData = jsonResponse['currentData'];
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

  @override
  void dispose() {
    _tabController.dispose();
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
            "Patients Enteries",
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 24,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Color.fromARGB(255, 181, 0, 100),
            labelColor: Color.fromARGB(255, 181, 0, 100),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Current',
              ),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(Duration(seconds: 1), () {
              setState(() {
                getPatientData();
              });
            });
          },
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                  child: Column(
                children: [
                  if (isLoading)
                    SizedBox(
                      height: 2,
                      child: LinearProgressIndicator(
                        color: Color.fromARGB(255, 181, 0, 100),
                      ),
                    )
                  else if (userData.isEmpty)
                    Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 3),
                        Text('No Data Found'),
                      ],
                    )
                  else
                    Column(
                      children: buildCurrentPatientWidgets(currentData),
                    ),
                ],
              )),
              SingleChildScrollView(
                  child: Column(
                children: [
                  if (isLoading)
                    SizedBox(
                      height: 2,
                      child: LinearProgressIndicator(
                        color: Color.fromARGB(255, 181, 0, 100),
                      ),
                    )
                  else if (userData.isEmpty)
                    Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 3),
                        Text('No Data Found'),
                      ],
                    )
                  else
                    Column(
                      children: buildPatientListWidgets(userData),
                    ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildPatientListWidgets(List<dynamic> userData) {
    return userData.map((user) {
      String uhid = '${user['UHID']}';
      String userId = '${user['_id']}';
      String deviceId = '${user['deviceId']}';

      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 45, 45),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Patient Name :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'UHID :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Age :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Weight :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Hight :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Ward No. :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),

                          // Text('Last Active :'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${user['patientName']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['UHID']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['age']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['weight']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['height']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['ward_no']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
             
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DosageHistory(uhid)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 181, 0, 100),
                      ),
                      child: Text(
                        "View Medication",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<Widget> buildCurrentPatientWidgets(List<dynamic> currentData) {
    return currentData.map((user) {
      String uhid = '${user['UHID']}';
      String userId = '${user['_id']}';
      String deviceId = '${user['deviceId']}';

      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 45, 45),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Patient Name :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'UHID :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Age :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Weight :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Hight :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Ward No. :',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),

                          // Text('Last Active :'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${user['patientName']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['UHID']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['age']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['weight']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['height']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['ward_no']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),

                          // Text('${user['lastLogin']}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  if(uhid.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DosageHistory(uhid)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 181, 0, 100),
                        ),
                        child: Text(
                          "View Medication",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddPatientData(uhid,deviceId,userId)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          "Edit Details",
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
                    ],
                  )else ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddPatientData(uhid, deviceId, userId)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          "Add Details",
                          style: TextStyle(color: Colors.pink),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
