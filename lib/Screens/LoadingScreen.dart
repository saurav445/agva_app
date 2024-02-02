// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'package:agva_app/Screens/DeviceDetails.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen();

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      backToScreen();
    });
  }

  Future<void> backToScreen() async {
    {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DeviceDetails(
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
       )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/agvaload.gif",
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
