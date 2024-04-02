// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:agva_app/Screens/Doctor&Assistant/DoctorHomeScreen.dart';
import 'package:agva_app/Screens/Doctor&Assistant/NurseHomeScreen.dart';
import 'package:agva_app/Screens/User/UserHomeScreen.dart';
import 'package:agva_app/Service/MessagingService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    getUserType();
    notificationCounts = MessagingService.notifications.length;
    print('notificationCounts inscreen $notificationCounts');

    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

  int notificationCounts = MessagingService.notifications.length;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: MessagingService.notifications.length,
        itemBuilder: (context, index) {
          // Access notification data
          final notification = MessagingService.notifications[index];
          final notificationData = notification.data;
          final title = notification.notification!.title ?? "";
          final body = notification.notification!.body ?? "";

          return Dismissible(
            direction: DismissDirection.endToStart,
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                MessagingService.notifications.removeAt(index);
              });
            },
            background: Container(
              color: Color.fromARGB(255, 202, 13, 0),
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
                            title,
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            body,
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: 20,
                          child: Image.asset('assets/images/Logo.png'))
                    ],
                  ),
                ),
              ),

              // title: Text(title),
              // subtitle: Text(body),
              onTap: () {
                _handleNotificationTap(context, notificationData);
              },
            ),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, Map<String, dynamic> data) {
    if (data.containsKey('screen')) {
      final screen = data['screen'];
      Navigator.of(context).pushNamed(screen);
    }
  }
}
