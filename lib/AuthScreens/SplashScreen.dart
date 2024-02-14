import 'dart:async';
import 'package:agva_app/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './SignIn.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      checkIfLoggedIn();
    });
  }

Future<String?> gethospital() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? hospitalName = prefs.getString('hospitalName');
  print('Retrieved hospital name: $hospitalName');
  return hospitalName;
}
Future<String?> gethospitalAddress() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? hospitalAddress = prefs.getString('hospitalAddress');
  print('Retrieved hospital address: $hospitalAddress');
  return hospitalAddress;
}

Future<void> checkIfLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedToken = prefs.getString('mytoken') ?? "";
  String storedHospital = await gethospital() ?? "";
  String storedHospitalAddress = await gethospitalAddress() ?? "";

  if (storedToken.isNotEmpty) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen({'hospitalName': storedHospital, 'hospitalAddress': storedHospitalAddress, })),
    );
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/AGVA.gif",
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
