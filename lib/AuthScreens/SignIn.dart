// ignore_for_file: unused_field, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, file_names, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:agva_app/AuthScreens/SignUp.dart';
import 'package:agva_app/Service/ProductsService.dart';
import 'package:agva_app/Screens/Doctor&Assistant/DoctorHomeScreen.dart';
import 'package:agva_app/Screens/Doctor&Assistant/NurseHomeScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool passwordVisible = true;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getToken();
    initSharedPref();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  String mytoken = "token";

  late String token;
  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    print(' signin FCM Token: $token');
  }

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        var response = await http.post(
          Uri.parse(loginUser),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": emailController.text.trim(),
            "passwordHash": passwordController.text,
          }),
        );

        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['statusValue'] == 'SUCCESS') {
          print(jsonResponse);
          var data = jsonResponse['data'];
          var name = data['name'];
          var email = data['email'];
          var token = data['token'];
          var hospitalName = data['hospitalName'];
          var hospitalAddress = data['hospitalAddress'];
          var usertype = data['userType'];
          var userID = data['_id'];
          var securityCode = data['securityCode'];
          var designation = data['designation'];
          var speciality = data['speciality'];
          var phoneno = data['contactNumber'];

          saveUsername(name);
          saveUseremail(email);
          saveToken(token);
          saveHospital(hospitalName);
          saveHospitalAddress(hospitalAddress);
          saveusertype(usertype);
          saveuserID(userID);
          savesecurityCode(securityCode);
          savedesignation(designation);
          saveSpeciality(speciality);
          savePhoneno(phoneno);

          // if (usertype == 'User') {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => UserHomeScreen({
          //         'hospitalName': hospitalName,
          //         'name': name,
          //         'hospitalAddress': hospitalAddress
          //       }),
          //     ),
          //   );
          // } else
           if (usertype == 'Assistant') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NurseHomeScreen({
                  'hospitalName': hospitalName,
                  'name': name,
                  'hospitalAddress': hospitalAddress
                }),
              ),
            );
          } else if (usertype == 'Doctor') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoctorHomeScreen({
                  'hospitalName': hospitalName,
                  'name': name,
                  'hospitalAddress': hospitalAddress
                }),
              ),
            );
          }
        } else {
          print(jsonResponse);
          var data = jsonResponse['data'];
          var err = data['err'];
          var msg = err['msg'];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg.toString(),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                      child: Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 20,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 218, 0, 138),
                                  Color.fromARGB(255, 142, 0, 90)
                                ])),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(),
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  Future<void> savesecurityCode(String securityCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('securityCode', securityCode);
    print('Saved securityCode: $securityCode');
  }

  Future<void> savedesignation(String designation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('designation', designation);
    print('Saved designation: $designation');
  }

  Future<void> saveSpeciality(String speciality) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('speciality', speciality);
    print('Saved Speciality: $speciality');
  }

  Future<void> savePhoneno(String phoneno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phoneno', phoneno);
    print('Saved phoneno: $phoneno');
  }

  Future<void> saveUsername(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    print('Saved username: $name');
  }

  Future<void> saveUseremail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    print('Saved useremail: $email');
  }

  Future<void> saveToken(String mytoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mytoken', mytoken);
  }

  Future<void> saveuserID(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', userID);
  }

  Future<void> saveHospital(String hospitalName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('hospitalName', hospitalName);
    print('Saved hospital name: $hospitalName');
  }

  Future<void> saveHospitalAddress(String hospitalAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('hospitalAddress', hospitalAddress);
    print('Saved hospital address: $hospitalAddress');
  }

  Future<void> saveusertype(String usertype) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('usertype', usertype);
    print('Saved usertype: $usertype');
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email';
    } else if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return null;
    }
    return 'Invalid Email';
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter password';
      // }else if (RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$').hasMatch(value)){
      //   return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 0),
              Text(
                "AgVa",
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: 60,
                  color: Color.fromARGB(255, 181, 0, 100),
                ),
              ),
              SizedBox(height: 60),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        controller: emailController,
                        validator: validateEmail,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          icon: Icon(Icons.email, color: Colors.white70),
                          // errorText: _isNotValidate ? "Enter Proper Info" : null,
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: passwordVisible,
                        validator: validatePassword,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock, color: Colors.white70),
                          hintText: 'Enter your Password',
                          // errorText: _isNotValidate ? "Enter Proper Info" : null,
                          hintStyle: TextStyle(color: Colors.white70),
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(230, 20, 0, 0),
              //   child: Row(
              //     children: [
              //       InkWell(
              //         child: Text(
              //           "Forget Password ?",
              //           style: TextStyle(
              //               color: Colors.white70, fontSize: 14),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                child: Container(
                  height: 45,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 218, 0, 138),
                        Color.fromARGB(255, 142, 0, 90),
                      ],
                    ),
                  ),
                  child: TextButton(
                    onPressed: signIn,
                    style: TextButton.styleFrom(),
                    child: Text(
                      "SIGN IN",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                child: Container(
                  height: 45,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                      ],
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(),
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                        color: Color.fromARGB(255, 157, 0, 86),
                        fontSize: 15,
                      ),
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
                      builder: (context) => Products(),
                    ),
                  );
                  print('Terms and Conditions clicked');
                },
                child: Text(
                  "Continue as Guest",
                  style: TextStyle(
                    color: Color.fromARGB(148, 255, 255, 255),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
