// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<String> projectNames = [];

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  void fetchProjects() async {
    String? token = await getToken();
    if (token != null) {
      print(token);
      var response = await http.get(
        Uri.parse(getProjects),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 1) {
        var data = jsonResponse['data'];
        var projectList = data['data'];
        for (var project in projectList) {
          var name = project['name'];
          setState(() {
            projectNames.add(name);
          });
        }
      } else {
        print('Invalid User Credential: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: ListView.builder(
                itemCount: projectNames.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 150,
                              width: 100,
                              child: Image.asset(
                                "assets/images/AgVaCrop.png",
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              projectNames[index],
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 58, 58, 58),
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })),
      ),
    );
  }
}
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     height: 200,
              //     width: 200,
              //     decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 1,
              //       blurRadius: 10,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              //           color: Colors.white,
              //               ),
              //     child: 

              
                // String getImagePath(String message) {
                //   switch (message) {
                //     case 'ACTIVE':
                //       return "assets/images/active.png";
                //     case 'INACTIVE':
                //       return "assets/images/inactive.png";
                //     default:
                //       return "assets/images/inactive.png";
                //   }
                // }
            