// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:agva_app/AuthScreens/SignIn.dart';
import 'package:agva_app/Screens/Common/RegDone.dart';
import 'package:agva_app/Screens/Common/TermsCondition.dart';
import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPhoneNumberFilled = false;
  bool passwordVisible = false;
  bool _isNotValidate = false;
  bool first = false;

  String specialitydropdown = 'Select Speciality';
  var specialityItems = [
    'Select Speciality',
    'Neuro',
    'Anesthesiologist',
    'Nurse',
  ];

  String designationdropdown = 'Select Designation';
  var designationItems = [
    'Select Designation',
    'Dr.',
    'Dr. Prof.',
    'Prof.',
    'Nurse',
    'Support Staff',
    'Engineer',
    'Admin',
    'Owner',
  ];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController hospitalNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController specialityController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void register() async {
    if (firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        hospitalNameController.text.isNotEmpty &&
        designationController.text.isNotEmpty &&
        departmentController.text.isNotEmpty &&
        specialityController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var regBody = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "hospitalName": hospitalNameController.text,
        "designation": designationController.text,
        "department": departmentController.text,
        "speciality": specialityController,
        "contactNumber": contactNumberController.text,
        "email": emailController.text,
        "passwordHash": passwordController.text,
      };

      var response = await http.post(
        Uri.parse(registerUser),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegDone()),
        );
      } else {
        print("Something Went Wrong");
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //         colors: [Colors.white, Colors.white])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(alignment: Alignment.center, children: [
            SingleChildScrollView(
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          "AgVa",
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 40,
                            color: Color.fromARGB(255, 157, 0, 86),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 35),
                          child: Container(
                            width: 330,
                            decoration: BoxDecoration(),
                            child: DropdownButtonFormField(
                              value: designationdropdown,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.0,
                              ),
                              isDense: true,
                              decoration: InputDecoration(
                                icon: FaIcon(
                                  FontAwesomeIcons.clipboardUser,
                                  size: 20,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 15,
                                ),
                                border: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white70,
                                    width: 0.7,
                                  ),
                                ),
                              ),
                              items: designationItems.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  designationdropdown = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 30),
                          child: TextFormField(
                            controller: firstNameController,
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Colors.white70,
                              ),
                              hintText: 'First Name',
                              errorText:
                                  _isNotValidate ? "Enter Proper Info" : null,
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 30),
                          child: TextFormField(
                            controller: lastNameController,
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Colors.white70,
                              ),
                              hintText: 'Last Name',
                              errorText:
                                  _isNotValidate ? "Enter Proper Info" : null,
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 30),
                          child: TextFormField(
                            controller: hospitalNameController,
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              icon: FaIcon(
                                FontAwesomeIcons.squareH,
                                size: 20,
                              ),
                              hintText: 'Enter Hospital Name',
                              errorText:
                                  _isNotValidate ? "Enter Proper Info" : null,
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 30),
                          child: TextFormField(
                            controller: designationController,
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              icon: FaIcon(
                                FontAwesomeIcons.userDoctor,
                                size: 20,
                              ),
                              hintText: 'Enter your Designation',
                              errorText:
                                  _isNotValidate ? "Enter Proper Info" : null,
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 30),
                          child: TextFormField(
                            controller: departmentController,
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              icon: FaIcon(
                                FontAwesomeIcons.hospitalUser,
                                size: 20,
                              ),
                              hintText: 'Enter your Department',
                              errorText:
                                  _isNotValidate ? "Enter Proper Info" : null,
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 35),
                          child: Container(
                            width: 330,
                            decoration: BoxDecoration(),
                            child: DropdownButtonFormField(
                              value: specialitydropdown,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.0,
                              ),
                              isDense: true,
                              decoration: InputDecoration(
                                icon: FaIcon(
                                  FontAwesomeIcons.clipboardUser,
                                  size: 20,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 15,
                                ),
                                border: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white70,
                                    width: 0.7,
                                  ),
                                ),
                              ),
                              items: specialityItems.map((String item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  specialitydropdown = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      //   Padding(
                      //     padding: const EdgeInsets.only(right: 30, left: 30),
                      //     child: IntlPhoneField(
                      //       controller: contactNumberController,
                      //       initialCountryCode: 'IN',
                      //       style: TextStyle(color: Colors.white70),
                      //       decoration: InputDecoration(
                      //         icon: FaIcon(
                      //           FontAwesomeIcons.phone,
                      //           size: 20,
                      //         ),
                      //         hintText: 'Contact Number',
                      //         errorText:
                      //             _isNotValidate ? "Enter Proper Info" : null,
                      //         hintStyle: TextStyle(color: Colors.white70),
                      //       ),
                      //       onChanged: (phone) {
                      //         setState(() {
                      //        isPhoneNumberFilled = phone.number.isNotEmpty;
                      //         });
                      //       },
                      //     ),
                      //   ),
                      //      if (isPhoneNumberFilled)
                      // Padding(
                      //     padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                      //     child: Container(
                      //       height: 45,
                      //       width: 100,
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(50),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.grey.withOpacity(0.3),
                      //               spreadRadius: 3,
                      //               blurRadius: 20,
                      //               offset: Offset(
                      //                   0, 3), // changes position of shadow
                      //             ),
                      //           ],
                      //           color: Colors.white,
                      //           gradient: LinearGradient(
                      //               begin: Alignment.topCenter,
                      //               end: Alignment.bottomCenter,
                      //               colors: [
                      //                 Color.fromARGB(255, 218, 0, 138),
                      //                 Color.fromARGB(255, 142, 0, 90)
                      //               ])),
                      //       child: TextButton(
                      //          onPressed: () {
                      //       // Implement your verification logic here
                      //       print('Verify button pressed');
                      //     },
                      //         style: TextButton.styleFrom(),
                      //         child: Text(
                      //           "Verify",
                      //           style: TextStyle(
                      //               color: Colors.white, fontSize: 15),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 30),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.email,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your Email',
                              errorText:
                                  _isNotValidate ? "Enter Proper Info" : null,
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 30),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: passwordVisible,
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                              hintText: 'Enter your Password',
                              errorText:
                                  _isNotValidate ? "Enter Proper Info" : null,
                              hintStyle: TextStyle(color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, left: 30),
                          child: TextFormField(
                            controller: confirmPasswordController,
                            obscureText: passwordVisible,
                            style: TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock,
                                color: Colors.white70,
                              ),
                              hintText: 'Confirm Password',
                              errorText:
                                  _isNotValidate ? "Enter Proper Info" : null,
                              hintStyle: TextStyle(color: Colors.white70),
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: first,
                              activeColor:
                                  const Color.fromARGB(255, 184, 46, 92),
                              checkColor: Colors.white,
                              onChanged: (bool? value) {
                                setState(() {
                                  first = value!;
                                });
                              },
                            ),
                            Text(
                              "I agree with ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TermsCondition(),
                                  ),
                                );
                                print('Terms and Conditions clicked');
                              },
                              child: Text(
                                "Terms and Conditions",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
                              onPressed: register,
                              style: TextButton.styleFrom(),
                              child: Text(
                                "SIGN UP",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromARGB(255, 255, 255, 255),
                                      Color.fromARGB(255, 255, 255, 255)
                                    ])),
                            child: TextButton(
                              style: TextButton.styleFrom(),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignIn(),
                                  ),
                                );
                              },
                              child: Text(
                                "SIGN IN",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 157, 0, 86),
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                      ])),
            )
          ])),
    );
  }
}
