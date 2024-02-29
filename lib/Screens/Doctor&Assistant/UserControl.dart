// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserControl extends StatefulWidget {
  @override
  State<UserControl> createState() => _UserControlState();
}

class _UserControlState extends State<UserControl> {
  List<dynamic> userData = [];
  List<dynamic> inactiveuserData = [];
  List<dynamic> pendinguserData = [];
  String updateUser = 'Inactive';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getActiveUser();
    getinActiveUser();
    getPendingUser();
  }

  void userStatusUpdate(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');

    if (mytoken != null) {
      var response = await http.put(
        Uri.parse('$updateUserstatus/$userID'),
        headers: {
          "Authorization": 'Bearer $mytoken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"accountStatus": updateUser}),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var data = jsonResponse['data'];
        var updateCurrentUser = data['accountStatus'];
        setState(() {
          print(updateCurrentUser);
        });
        getActiveUser();
      } else {
        print('Failed to update focus status: ${response.statusCode}');
      }
    } else {
      print("Token is null");
    }
  }

  void getActiveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    if (mytoken != null) {
      var response = await http.get(
        Uri.parse(getActiveUsers),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusCode'] == 200) {
        setState(() {
          userData = jsonResponse['data'];
          isLoading = false;
        });
      } else {
        print('Invalid User Credential: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void getinActiveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    if (mytoken != null) {
      var response = await http.get(
        Uri.parse(getInactiveUsers),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusCode'] == 200) {
        setState(() {
          inactiveuserData = jsonResponse['data'];
        });
      } else {
        print('Invalid User Credential: ${response.statusCode}');
      }
    }
  }

  void getPendingUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    if (mytoken != null) {
      var response = await http.get(
        Uri.parse(getPendingUsers),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['statusCode'] == 200) {
        setState(() {
          pendinguserData = jsonResponse['data'];
        });
      } else {
        print('Invalid User Credential: ${response.statusCode}');
      }
    }
  }
// String formatDateTime(String dateTimeString) {
//   DateTime dateTime = DateTime.parse(dateTimeString);
//   return DateFormat.yMd().add_jm().format(dateTime);
// }

  List<Widget> buildPendingUserWidgets(List<dynamic> pendinguserData) {
    return pendinguserData.map((user) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: 180,
            width: 350,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 60, 60, 60),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Name :'),
                          Text('Speciality :'),
                          Text('Contact :'),
                          Text('UserID:'),
                          // Text('Last Active :'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${user['firstName']} ${user['lastName']}'),
                          Text('${user['speciality']}'),
                          Text('${user['contactNumber']}'),
                          Text('${user['_id']}'),
                          // Text('${user['lastLogin']}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 218, 0, 138),
                                Color.fromARGB(255, 142, 0, 90)
                              ])),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(),
                        child: Text(
                          "Remove",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

// inactive user list
  List<Widget> buildInactiveUserWidgets(List<dynamic> inactiveuserData) {
    return inactiveuserData.map((user) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: 180,
            width: 350,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 60, 60, 60),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Name :'),
                          Text('Speciality :'),
                          Text('Contact :'),
                          Text('UserID:'),
                          // Text('Last Active :'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${user['firstName']} ${user['lastName']}'),
                          Text('${user['speciality']}'),
                          Text('${user['contactNumber']}'),
                          Text('${user['_id']}'),
                          // Text('${user['lastLogin']}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 218, 0, 138),
                                Color.fromARGB(255, 142, 0, 90)
                              ])),
                      child: TextButton(
                        onPressed: () {
                          // Remove user logic
                        },
                        style: TextButton.styleFrom(),
                        child: Text(
                          "Remove",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  // active user list

  List<Widget> buildActiveUserWidgets(
      List<dynamic> userData, Function(String) userStatusUpdate) {
    return userData.map((user) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: 180,
            width: 350,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 60, 60, 60),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Name :'),
                          Text('Speciality :'),
                          Text('Contact :'),
                          Text('UserID:'),
                          // Text('Last Active :'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${user['firstName']} ${user['lastName']}'),
                          Text('${user['speciality']}'),
                          Text('${user['contactNumber']}'),
                          Text('${user['_id']}'),
                          // Text('${user['lastLogin']}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                    child: Container(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () async {
                          await userStatusUpdate(user['_id']);
                        },
                        child: Text(
                          "Remove",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              "User Control",
              style: TextStyle(
                fontFamily: 'Avenir',
                fontSize: 24,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return _buildPortraitLayout(context, userData);
            } else {
              return _buildLandscapeLayout(context);
            }
          })),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, List<dynamic> userData) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.035,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 60, 60, 60),
                  ),
                  child: Text(
                    'Inactive',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 60, 60, 60),
                  ),
                  child: Text(
                    'Pending',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.035,
        ),
        if (isLoading)
          SizedBox(
              height: 1,
              child: Center(child: LinearProgressIndicator(color: Colors.pink)))
        // SizedBox(height: 1, child: Center(child: Text('No data')));
        else
          Column(
            children: buildActiveUserWidgets(userData, userStatusUpdate),
          ),
        Column(
          children: buildInactiveUserWidgets(
            inactiveuserData,
          ),
        ),
        Column(
          children: buildPendingUserWidgets(pendinguserData),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.035,
        ),
      ],
    );
  }
}
