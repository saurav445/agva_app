// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:agva_app/Screens/DeviceDetails.dart';
import 'package:agva_app/Screens/HomeScreen.dart';
import 'package:agva_app/Screens/DeviceList.dart';
import 'package:flutter/material.dart';
import 'AuthScreens/SignIn.dart';
import 'AuthScreens/SignUp.dart';
import 'AuthScreens/SplashScreen.dart';
import 'Screens/TermsCondition.dart';
// import 'Service/SocketService.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SocketService().initializeSocket('http://192.168.2.1:8000');
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      routes: {
        "/signup": (context) => SignUp(),
        "/signin": (context) => SignIn(),
        "/splash": (context) => SplashScreen(),
        "/home": (context) => HomeScreen({}),
    "/devicedetails": (context) => DeviceDetails('', '', '','','', '', '', ''),

        "/tandc": (context) => TermsCondition(),
                        "/devicelist": (context) => DeviceList(),
      },
    );
  }
}