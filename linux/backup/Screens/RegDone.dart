import 'dart:async';
import 'package:flutter/material.dart';
import '../AuthScreens/SignIn.dart';

class RegDone extends StatefulWidget {
  const RegDone();

  @override
  State<RegDone> createState() => _RegDoneState();
}

class _RegDoneState extends State<RegDone> {
  @override
  void initState() {
    super.initState();
    // Start a timer to navigate to SignIn screen after 2 seconds
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignIn( )),
      );
    });
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
              "assets/images/RegDone.gif",
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
