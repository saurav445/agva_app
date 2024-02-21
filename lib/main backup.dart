
// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:agva_app/Screens/DeviceDetails.dart';
import 'package:agva_app/Screens/HomeScreen.dart';
import 'package:agva_app/Screens/DeviceList.dart';
import 'package:agva_app/Screens/NotificationScreen.dart';
import 'package:agva_app/Service/SocketService.dart';
import 'package:flutter/material.dart';
import 'AuthScreens/SignIn.dart';
import 'AuthScreens/SplashScreen.dart';
import 'Screens/TermsCondition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Service/firebase_service.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyAGeXq1HUM6_idigSAbWHolMNCdbjXTFJ8',
          appId: '1:679007550491:android:3a7d4bfafbaaa9f1e78cbe',
          messagingSenderId: '679007550491',
          projectId: 'agvaapp',
          storageBucket: 'agvaapp.appspot.com'));
          
  // await FirebaseService().initNotifications(); 
   final firebaseService = FirebaseService();
  await firebaseService.initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      routes: {
        "/signin": (context) => SignIn(),
        "/splash": (context) => const SplashScreen(),
        "/home": (context) => HomeScreen({}),
        "/devicedetails": (context) =>
            DeviceDetails('', SocketServices(), '', '', ''),
        "/tandc": (context) => TermsCondition(),
        "/devicelist": (context) => DeviceList(),
         "/notification": (context) => NotificationScreen(),

      },
    );
  }
}
