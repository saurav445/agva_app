// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? savedUsername;
  String? saveUseremail;
  String? savedhospitalName;
  String? savedhospitalAddress;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getUsername().then((name) {
      setState(() {
        savedUsername = name;
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
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    print('Retrieved Username: $name');
    return name;
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
    print('Retrieved Username: $hospitalAddress');
    return hospitalAddress;
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
              return ProfilePortrait(savedUsername, saveUseremail,
                  savedhospitalName, savedhospitalAddress);
            } else {
              return ProfileLandscape(savedUsername, saveUseremail,
                  savedhospitalName, savedhospitalAddress);
            }
          })),
    );
  }
}

class ProfileLandscape extends StatelessWidget {
  String? savedUsername;
  String? saveUseremail;
  String? savedhospitalName;
  String? savedhospitalAddress;

  ProfileLandscape(this.savedUsername, this.saveUseremail,
      this.savedhospitalName, this.savedhospitalAddress);

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
                          savedUsername ?? 'N/A',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'N/A',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'N/A',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          saveUseremail ?? 'N/A',
                          style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'N/A',
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
                //   Navigator.push(
                //       context, MaterialPageRoute(builder: (context) => ()));
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

class ProfilePortrait extends StatelessWidget {
  String? savedUsername;
  String? saveUseremail;
  String? savedhospitalName;
  String? savedhospitalAddress;

  ProfilePortrait(this.savedUsername, this.saveUseremail,
      this.savedhospitalName, this.savedhospitalAddress);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Designation :',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Speciality :',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email :',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone No.',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    savedUsername ?? 'N/A',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'N/A',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'N/A',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 10),
                  Text(
                    saveUseremail ?? 'N/A',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'N/A',
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
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
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            // onTap: () {
            //   Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => ()));
            // },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.9,
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
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          savedhospitalAddress ?? 'Hospital Address',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 218, 218, 218),
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
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
        ],
      ),
    );
  }
}
