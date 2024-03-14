// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'package:agva_app/AuthScreens/SignIn.dart';
import 'package:flutter/material.dart';

class RegDone extends StatefulWidget {
  const RegDone();

  @override
  State<RegDone> createState() => _RegDoneState();
}

class _RegDoneState extends State<RegDone> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignIn( )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/regdone.png",
                width: 150,
                fit: BoxFit.cover,
              ),
               SizedBox(
                height: 40,
              ),
              Text(
                'Congratulations!',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  color: Color.fromRGBO(203, 41, 122, 1),
                  fontSize: MediaQuery.of(context).size.width * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 1,
                width: 150,
                child: LinearProgressIndicator(color: Colors.pink,)
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: Text(
                  'You have successfully signed up with us, Please wait for approval.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
