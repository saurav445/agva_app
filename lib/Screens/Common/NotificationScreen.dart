// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sort_child_properties_last, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:agva_app/Screens/Doctor&Assistant/DoctorHomeScreen.dart';
import 'package:agva_app/Screens/Doctor&Assistant/NurseHomeScreen.dart';
import 'package:agva_app/Screens/User/UserHomeScreen.dart';
import 'package:agva_app/Service/MessagingService.dart';
import 'package:agva_app/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? token;
  List<dynamic> notificationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserType();
    getFCMtoken();
    getNotification();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<String?> getFCMtoken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    return token;
  }

  void getNotification() async {
    String? fcmToken = await getFCMtoken();
    if (fcmToken != null) {
      var response = await http.get(
        Uri.parse('$getnotificationList/$fcmToken'),
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusCode'] == 200) {

        setState(() {
          notificationList = jsonResponse['data'];
   
        });
      } else {
        print(response.statusCode);
     setState(() {
          notificationList = [];
        });
      }
    }
  }

  void removeNotification(String notificationID) async {
    print(notificationID);
    var response = await http.delete(
      Uri.parse('$deleteNotification/$notificationID'),
    );
    if (response.statusCode == 200) {
      getNotification();
      print('notification removed');
    } else {
      getNotification();
      print('Failed to remove: ${response.statusCode}');
    }
  }

  Future<String?> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usertype = prefs.getString('usertype');
    print('Retrieved usertype: $usertype');
    return usertype;
  }

  Future<void> checkandNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usertype = prefs.getString('usertype') ?? "";

    if (usertype == 'User') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => UserHomeScreen({})),
      );
    } else if (usertype == 'Assistant') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NurseHomeScreen({})),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DoctorHomeScreen({})),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'refresh');
          },
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Notifications"),
      ),
      body: notificationList.isEmpty
          ? Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset('assets/images/NoNotification.png'),
              ),
            )
          : ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final notification = notificationList[index];

                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    var notificationID = notification['_id'];
                    removeNotification(notificationID);
                  },
                  background: Container(
                    color: Color.fromARGB(255, 202, 13, 0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 36,
                    ),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                  ),
                  child: ListTile(
                    title: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 55, 55, 55),
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
                                  notification['notification']['title'],
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    color: Color.fromARGB(255, 218, 218, 218),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    notification['notification']['body'],
                                    style: TextStyle(
                                        fontFamily: 'Avenir',
                                        color:
                                            Color.fromARGB(255, 218, 218, 218),
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //     height: 20,
                            //     child: Image.asset('assets/images/Logo.png'))
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _handleNotificationTap(context, notification);
                    },
                  ),
                );
              }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: StreamBuilder<Object>(
      //     stream: FirebaseMessaging.onMessage,
      //     builder: (context, snapshot) {
      //       return Visibility(
      //         visible: notificationList.isNotEmpty,
      //         child: Padding(
      //           padding: const EdgeInsets.only(bottom: 20),
      //           child: FloatingActionButton(
      //             backgroundColor: Color.fromARGB(0, 158, 158, 158),
      //             onPressed: () {
      //               setState(() {
      //                 MessagingService.notifications.clear();
      //               });
      //             },
      //             child: Image.asset('assets/images/clear.png'),
      //           ),
      //         ),
      //       );
      //     }),
    );
  }

  void _handleNotificationTap(BuildContext context, notification) {
    var screenData = notification['data']['screen'];

    Navigator.of(context).pushNamed(screenData);
  }
}

