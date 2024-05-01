// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_const, unused_import, library_private_types_in_public_api, prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:agva_app/AuthScreens/SignIn.dart';
import 'package:agva_app/Screens/Common/Profile.dart';
import 'package:agva_app/Screens/Doctor&Assistant/AddPatientData.dart';
import 'package:agva_app/Screens/Doctor&Assistant/AllPatientList.dart';
import 'package:agva_app/Screens/Doctor&Assistant/DeviceListAgVaPro.dart';
import 'package:agva_app/Screens/Doctor&Assistant/DoctorAlarmDevices.dart';
import 'package:agva_app/Screens/Doctor&Assistant/DoctorHospitals.dart';
import 'package:agva_app/Screens/Doctor&Assistant/DoctorMyDevices.dart';
import 'package:agva_app/Screens/Common/NotificationScreen.dart';
import 'package:agva_app/Screens/Doctor&Assistant/LiveWebView.dart';
import 'package:agva_app/Service/MessagingService.dart';
import 'package:agva_app/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Common/Settings.dart';

class NurseHomeScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  NurseHomeScreen(this.data);

  @override
  _NurseHomeScreenState createState() => _NurseHomeScreenState();
}

class _NurseHomeScreenState extends State<NurseHomeScreen> {
  // final _messagingService = MessagingService();
  String? saveUseremail;
  String? savedUsername;
  String? saveduserID;
  String? savedsecurityCode;
  late SharedPreferences prefs;
  String? token;
  int notificationCounts = MessagingService.notifications.length;

  void updateBadgeCount() {
    setState(() {
      notificationCounts = MessagingService.notifications.length;
    });
  }

  @override
  void initState() {
    super.initState();
    // _messagingService.init(context);
    // _messagingService.messageStream.listen((message) {
    //   updateBadgeCount();
    // });
    getsavedToken();
    getFCMtoken();
    getUsername().then((name) {
      setState(() {
        savedUsername = name;
      });
    });
    getSecuritycode().then((securityCode) {
      setState(() {
        savedsecurityCode = securityCode;
      });
    });
    getUserId().then((userID) {
      setState(() {
        saveduserID = userID;
      });
    });
    getUseremail().then((email) {
      setState(() {
        saveUseremail = email;
      });
    });
    sendFCM();

    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<String?> getFCMtoken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    // print(' FCM Token: $token');
    return token;
  }

  void sendFCM() async {
    String? jwttoken = await getsavedToken();
    String? fcmToken = await getFCMtoken();
    print(saveduserID);
    if (jwttoken != null) {
      print(' fcm token $fcmToken');
      var response = await http.post(
        Uri.parse(sendFCMandUserId),
        headers: {
          // "Authorization": 'Bearer $jwttoken̉̉',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"fcmToken": fcmToken, "userId": savedsecurityCode}),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
      } else {
        print('Failed ${response.statusCode}');
      }
    } else {
      print("Token is null");
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');
    print('Retrieved savedToken: $userID');
    return userID;
  }

  Future<String?> getsavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    print('Retrieved savedToken: $mytoken');
    return mytoken;
  }

  Future<String?> getUseremail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    print('Retrieved Useremail: $email');
    return email;
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    print('Retrieved Username: $name');
    return name;
  }

  Future<String?> getSecuritycode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? securityCode = prefs.getString('securityCode');
    print('Retrieved securityCode: $securityCode');
    return securityCode;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('mytoken');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: <Widget>[
            if (MessagingService.notifications.isNotEmpty)
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: 11, end: 11),
                // badgeContent: Text(notificationCounts.toString()),
                child: IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()),
                    );

                    if (result != null && result == 'refresh') {
                      updateBadgeCount();
                    }
                  },
                ),
              )
            else
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                },
              ),
          ],
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return SingleChildScrollView(child: _buildPortraitLayout(context));
          } else {
            return _buildLandscapeLayout(context);
          }
        }),
drawer: Drawer(
               width: MediaQuery.of(context).size.width / 2,
              backgroundColor: Colors.black,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
         
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color.fromARGB(255, 218, 0, 138),
                            Color.fromARGB(255, 117, 0, 74)
                          ])),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          
                          children: [
                            Image.asset(
                              'assets/images/profile.png',
                              height: 50,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.020,
                            ),
                            Text(
                              savedUsername ?? '-',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.025,
                              ),
                            ),
                            Text(
                              saveUseremail ?? '-',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: MediaQuery.of(context).size.width * 0.02,
                              ),
                            ),
                             Text(
                              '#$savedsecurityCode',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: MediaQuery.of(context).size.width * 0.02,
                              ),
                            ),
                          ],
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
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(
                      'PROFILE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: Text(
                      'SETTINGS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Settings(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                    onTap: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 172, 172, 172),
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    savedUsername ?? 'Default User Name',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllPatientList(),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 92, 74, 251),
                        Color.fromARGB(255, 30, 30, 30),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ALL PATIENTS',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 218, 218, 218),
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.22,
                            child: Image.asset("assets/images/nurse.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorMyDevices(),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 173, 25, 25),
                        Color.fromARGB(255, 254, 134, 134),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MY DEVICES',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 218, 218, 218),
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: Image.asset("assets/images/mydevices.png"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlarmDeviceList(),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 50, 50, 50),
                        Color.fromARGB(255, 255, 255, 255),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ALARMS',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 218, 218, 218),
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Image.asset("assets/images/alarmimage.png"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorHospitals(),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 225, 92, 156),
                        Color.fromARGB(255, 238, 44, 76),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ALL DEVICES',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 218, 218, 218),
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Image.asset("assets/images/deviceimage.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => WebView(),
              //       ),
              //     );
              //   },
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * 0.15,
              //     width: MediaQuery.of(context).size.width * 0.9,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.white,
              //       gradient: LinearGradient(
              //         begin: Alignment.bottomLeft,
              //         end: Alignment.topRight,
              //         colors: [
              //           Color.fromARGB(255, 92, 74, 251),
              //           Color.fromARGB(255, 30, 30, 30),
              //         ],
              //       ),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 30),
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text(
              //                 'AI',
              //                 style: TextStyle(
              //                   fontFamily: 'Avenir',
              //                   color: Color.fromARGB(255, 218, 218, 218),
              //                   fontSize:
              //                       MediaQuery.of(context).size.width * 0.05,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //               Text(
              //                 'COMING SOON..',
              //                 style: TextStyle(
              //                   fontFamily: 'Avenir',
              //                   color: Color.fromARGB(255, 218, 218, 218),
              //                   fontSize:
              //                       MediaQuery.of(context).size.width * 0.025,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(left: 15, top: 0),
              //             child: Container(
              //               width: MediaQuery.of(context).size.width * 0.4,
              //               child: Image.asset("assets/images/aiimage.png"),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.05,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 172, 172, 172),
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      savedUsername ?? 'Default User Name',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
              ),
              SingleChildScrollView(child: scrrollwidgetforlandscape()),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class scrrollwidgetforlandscape extends StatelessWidget {
  const scrrollwidgetforlandscape({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => AddPatientData(),
            //   ),
            // );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(255, 92, 74, 251),
                  Color.fromARGB(255, 30, 30, 30),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ADD DATA',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: MediaQuery.of(context).size.width * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        'Add Patient Data',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: MediaQuery.of(context).size.width * 0.030,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: Image.asset("assets/images/nurse.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorMyDevices(),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(255, 173, 25, 25),
                  Color.fromARGB(255, 254, 134, 134),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MY DEVICES',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 218, 218, 218),
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Image.asset("assets/images/mydevices.png"),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlarmDeviceList(),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(255, 50, 50, 50),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ALARMS',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 218, 218, 218),
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Image.asset("assets/images/alarmimage.png"),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorHospitals(),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(255, 225, 92, 156),
                  Color.fromARGB(255, 238, 44, 76),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ALL DEVICES',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 218, 218, 218),
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      // height:
                      //     MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Image.asset("assets/images/deviceimage.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
