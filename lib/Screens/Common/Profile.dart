// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? savedUsername;
  String? saveUseremail;
  String? savedhospitalName;
  String? savedhospitalAddress;
  String? saveduserID;
  String? savedsecurityCode;
  String? savedDesignation;
  String? savedspeciality;
  String? savedphoneno;
  bool isLoading = true;
  List<Map<String, dynamic>> devicesForUserList = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    fetchGetDevicesForUser();
    getUsername().then((name) {
      setState(() {
        savedUsername = name;
      });
    });
    getSecurityCode().then((securityCode) {
      setState(() {
        savedsecurityCode = securityCode;
      });
    });
    getDesignation().then((designation) {
      setState(() {
        savedDesignation = designation;
      });
    });
    getSpeciality().then((speciality) {
      setState(() {
        savedspeciality = speciality;
      });
    });
    getPhoneno().then((phoneno) {
      setState(() {
        savedphoneno = phoneno;
      });
    });

    getUseremail().then((email) {
      setState(() {
        saveUseremail = email;
      });
    });
    getHospital().then((hospitalName) {
      setState(() {
        savedhospitalName = hospitalName;
      });
    });
    getHospitalAddress().then((hospitalAddress) {
      setState(() {
        savedhospitalAddress = hospitalAddress;
      });
    });
    getUserID().then((userID) {
      setState(() {
        saveduserID = userID;
      });
    });
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    print('Retrieved Username: $name');
    return name;
  }

  Future<String?> getDesignation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? designation = prefs.getString('designation');
    print('Retrieved designation: $designation');
    return designation;
  }

  Future<String?> getSpeciality() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? speciality = prefs.getString('speciality');
    print('Retrieved Speciality: $speciality');
    return speciality;
  }
  Future<String?> getPhoneno() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneno = prefs.getString('phoneno');
    print('Retrieved Phoneno: $phoneno');
    return phoneno;
  }

  Future<String?> getSecurityCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? securityCode = prefs.getString('securityCode');
    return securityCode;
  }

  Future<String?> getUseremail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    print('Retrieved Useremail: $email');
    return email;
  }

  Future<String?> getHospital() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hospitalName = prefs.getString('hospitalName');
    print('Retrieved Username: $hospitalName');
    return hospitalName;
  }

  Future<String?> getHospitalAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hospitalAddress = prefs.getString('hospitalAddress');
    print('Retrieved Hospital Address: $hospitalAddress');
    return hospitalAddress;
  }

  Future<String?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');
    print('Retrieved userID: $userID');
    return userID;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  Future<void> fetchGetDevicesForUser() async {
    setState(() {
      isLoading = true;
    });
    String? userid = await getUserID();
    print(userid);
    String? token = await getToken();

    if (token != null) {
      var response = await http.get(
        Uri.parse('$getProfile/$userid'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        var data = jsonResponse['data'];
        devicesForUserList = List<Map<String, dynamic>>.from(data['profile']);

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

  //  '${profileInfo['associationName']}',

  List<Widget> buildDeviceList() {
    return devicesForUserList.map((data) {
      print(data);
      String associationName = data['associationName'];
      String workAddress = data['workAddress'];
      String workEmail = data['workEmail'];
      String department = data['department'];
      // String startDate = data['startDate'];
      // String endDate = data['endDate'];
      // String workPhoneNo = data['workPhoneNo'];
      // String designation = data['designation'];

      return ListTile(
        title: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 41, 41, 41),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      associationName,
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Text(
                      'Department: $department',
                      style: TextStyle(
                          fontFamily: 'Avenir',
                          color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.005,
                    ),
                    Text(
                      'Work Email: $workEmail',
                      style: TextStyle(
                          fontFamily: 'Avenir',
                          color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.005,
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        'Address: $workAddress',
                        style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 218, 218, 218),
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
              'Profile',
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return SingleChildScrollView(
                  child: _buildPortraitLayout(context));
            } else {
              return ProfileLandscape(savedUsername, saveUseremail,
                  savedhospitalName, savedhospitalAddress);
            }
          })),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Image.asset("assets/images/profile.png"),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Color.fromARGB(255, 181, 0, 100),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name :',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Doc Code :',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Designation :',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Speciality :',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Email :',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Phone No.',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          savedUsername ?? '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          savedsecurityCode ?? '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          savedDesignation ?? '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                         savedspeciality ?? '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          saveUseremail ?? '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          savedphoneno ?? '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 12,
                              fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 1,
                  child: Container(
                    color: Color.fromARGB(255, 181, 0, 100),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (isLoading)
            SizedBox(
                height: 1,
                child:
                    Center(child: LinearProgressIndicator(color: Colors.pink)))
          else
            Column(
              children: 
              [ Text(
                      'Associations',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: MediaQuery.of(context).size.width * 0.050,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                Column(
                  children: buildDeviceList(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ProfileLandscape extends StatelessWidget {
  String? savedUsername;
  String? saveUseremail;
  String? savedhospitalName;
  String? savedhospitalAddress;

  ProfileLandscape(this.savedUsername, this.saveUseremail,
      this.savedhospitalName, this.savedhospitalAddress, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Image.asset("assets/images/profile.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name :',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Designation :',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Speciality :',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Email :',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Phone No.',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          savedUsername ?? '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          saveUseremail ?? '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '-',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 1,
            child: Container(
              color: Color.fromARGB(255, 181, 0, 100),
            ),
          ),
          Column(
            children: [
              GestureDetector(
                // onTap: () {
                // Navigator.push(
                // context, MaterialPageRoute(builder: (context) => ()));
                // },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color.fromARGB(255, 65, 65, 65),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              savedhospitalName ?? 'Hospital Name',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              savedhospitalAddress ?? 'Hospital Address',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.01,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Image.asset("assets/images/hospital.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
