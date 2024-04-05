// ignore_for_file: prefer_const_constructors

import 'package:agva_app/AuthScreens/RegDone.dart';
import 'package:agva_app/Screens/Common/NotificationScreen.dart';
import 'package:agva_app/Screens/Common/TermsCondition.dart';
import 'package:agva_app/Screens/Doctor&Assistant/DoctorHomeScreen.dart';
import 'package:agva_app/Screens/Doctor&Assistant/NurseHomeScreen.dart';
import 'package:agva_app/Screens/Doctor&Assistant/UserControl.dart';
import 'package:agva_app/Screens/User/DeviceDetails.dart';
import 'package:agva_app/Screens/User/DeviceList.dart';
import 'package:agva_app/Screens/User/UserHomeScreen.dart';
import 'package:agva_app/Service/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'AuthScreens/SignIn.dart';
import 'AuthScreens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

final navigatorKey = GlobalKey<NavigatorState>();



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    getToken();
  }

  late String token;
  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    // print(' FCM Token: $token');
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        theme: ThemeData(primarySwatch: Colors.blue),
        darkTheme: ThemeData(brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        initialRoute: "/splash",
        routes: {
          "/regdone": (context) => RegDone(),
          "/signin": (context) => SignIn(),
          "/splash": (context) => const SplashScreen(),
          "/userhome": (context) => UserHomeScreen({}),
          "/doctorhome": (context) => DoctorHomeScreen({}),
          "/nursehome": (context) => NurseHomeScreen({}),
          "/devicedetails": (context) => DeviceDetails('', '', '', ''),
          "/tandc": (context) => TermsCondition(),
          "/devicelist": (context) => DeviceList(),
          "/notification": (context) => NotificationScreen(),
          "/usercontrol": (context) => UserControl(),
        },
      ),
    );
  }
}
