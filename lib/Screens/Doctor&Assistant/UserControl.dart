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

class _UserControlState extends State<UserControl>
    with SingleTickerProviderStateMixin {
  List<dynamic> userData = [];
  List<dynamic> inactiveuserData = [];
  List<dynamic> requestsuserData = [];
  String updateUser = 'Active Users';
  bool isLoading = true;
  bool getdata = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    getActiveUser();
    getPendingUser();
  }

  void _handleTabSelection() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          updateUser = 'Active Users';
          getActiveUser();
          break;
        case 1:
          updateUser = 'InActive Users';
          getinActiveUser();
          break;
        case 2:
          updateUser = 'Requests';
          getPendingUser();
          break;
      }
    });
  }

  void removeUser(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');

    if (mytoken != null) {
      var response = await http.put(
        Uri.parse('$updateUserstatus/$userID'),
        headers: {
          "Authorization": 'Bearer $mytoken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"accountStatus": "Inactive"}),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('user removed');
        setState(() {
          getActiveUser();
          getPendingUser();
        });
      } else {
        print('Failed to update focus status: ${response.statusCode}');
      }
    } else {
      print("Token is null");
    }
  }

  void activeUser(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');

    if (mytoken != null) {
      var response = await http.put(
        Uri.parse('$updateUserstatus/$userID'),
        headers: {
          "Authorization": 'Bearer $mytoken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"accountStatus": "Active"}),
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('user active');
        getinActiveUser();
        getPendingUser();
      } else {
        print('Failed to update focus status: ${response.statusCode}');
      }
    } else {
      print("Token is null");
    }
  }

  void getActiveUser() async {
    setState(() {
      isLoading = true;
    });

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
    setState(() {
      isLoading = true;
    });

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
      if (jsonResponse['statusCode'] == 200) {
        setState(() {
          inactiveuserData = jsonResponse['data'];
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

  void getPendingUser() async {
    setState(() {
      isLoading = true;
    });
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
      if (jsonResponse['statusCode'] == 200) {
        setState(() {
          requestsuserData = jsonResponse['data'];
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> buildRequestsUserWidgets(List<dynamic> requestsuserData,
      Function(String) removeUser, Function(String) activeUser) {
    return requestsuserData.map((user) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 45, 45),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.all(10),
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
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${user['firstName']} ${user['lastName']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['speciality']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['contactNumber']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                        child: Container(
                          height: 30,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await activeUser(user['_id']);
                              setState(() {
                                isLoading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 181, 0, 100),
                            ),
                            child: Text(
                              "Accept",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                        child: Container(
                          height: 30,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await removeUser(user['_id']);
                              setState(() {
                                isLoading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              "Remove",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<Widget> buildInactiveUserWidgets(
      List<dynamic> inactiveuserData, Function(String) activeUser) {
    return inactiveuserData.map((user) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 45, 45),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.all(10),
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
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${user['firstName']} ${user['lastName']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['speciality']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['contactNumber']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
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
                      child: StatefulBuilder(builder: (context, setState) {
                        return ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await activeUser(user['_id']);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 181, 0, 100),
                          ),
                          child: Text(
                            isLoading ? 'Processing' : 'Active',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        );
                      }),
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

  List<Widget> buildActiveUserWidgets(
      List<dynamic> userData, Function(String) removeUser) {
    return userData.map((user) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 45, 45, 45),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.all(10),
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
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${user['firstName']} ${user['lastName']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['speciality']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          Text(
                            '${user['contactNumber']}',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
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
                      child: StatefulBuilder(builder: (context, setState) {
                        return ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await removeUser(user['_id']);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 181, 0, 100),
                          ),
                          child: Text(
                            isLoading ? 'Processing' : 'Remove',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        );
                      }),
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
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Color.fromARGB(255, 181, 0, 100),
            labelColor: Color.fromARGB(255, 181, 0, 100),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Active Users',
              ),
              Tab(
                text: 'Inactive Users',
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Requests'),
                    if (requestsuserData.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: ImageIcon(
                          AssetImage('assets/images/pinkdot.png'),
                          size: 8,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
                child: Column(
              children: [
                if (isLoading)
                  SizedBox(
                    height: 2,
                    child: LinearProgressIndicator(
                      color: Color.fromARGB(255, 181, 0, 100),
                    ),
                  )
                else if (userData.isEmpty)
                  Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 3),
                      Text('No Data Found'),
                    ],
                  )
                else
                  Column(
                    children: buildActiveUserWidgets(userData, removeUser),
                  ),
              ],
            )),
            SingleChildScrollView(
                child: Column(
              children: [
                if (isLoading)
                  SizedBox(
                    height: 2,
                    child: LinearProgressIndicator(
                      color: Color.fromARGB(255, 181, 0, 100),
                    ),
                  )
                else if (inactiveuserData.isEmpty)
                  Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 3),
                      Text('No Data Found'),
                    ],
                  )
                else
                  Column(
                    children:
                        buildInactiveUserWidgets(inactiveuserData, activeUser),
                  ),
              ],
            )),
            SingleChildScrollView(
                child: Column(
              children: [
                if (isLoading)
                  SizedBox(
                    height: 2,
                    child: LinearProgressIndicator(
                      color: Color.fromARGB(255, 181, 0, 100),
                    ),
                  )
                else if (requestsuserData.isEmpty)
                  Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 3),
                      Text('No Data Found'),
                    ],
                  )
                else
                  Column(
                    children: buildRequestsUserWidgets(
                        requestsuserData, activeUser, removeUser),
                  ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    updateUser = 'Active Users';
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: updateUser == 'Active Users'
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Active Users',
                    style: TextStyle(
                      color: updateUser == 'Active Users'
                          ? Colors.black
                          : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    updateUser = 'InActive Users';
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: updateUser == 'InActive Users'
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: Text(
                    'InActive Users',
                    style: TextStyle(
                      color: updateUser == 'InActive Users'
                          ? Colors.black
                          : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    updateUser = 'Requests';
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: updateUser == 'Requests'
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: Text(
                    'Requests',
                    style: TextStyle(
                      color: updateUser == 'Requests'
                          ? Colors.black
                          : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
            child: Center(child: LinearProgressIndicator(color: Colors.pink)),
          )
        else
          Column(
            children: updateUser == 'Active Users'
                ? buildActiveUserWidget(userData, removeUser)
                : updateUser == 'InActive Users'
                    ? buildInactiveUserWidget(inactiveuserData, activeUser)
                    : buildRequestsUserWidget(
                        requestsuserData, activeUser, removeUser),
          ),
      ],
    );
  }

  List<Widget> buildRequestsUserWidget(List<dynamic> requestsuserData,
      Function(String) removeUser, Function(String) activeUser) {
    return requestsuserData.map((user) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
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

                          // Text('${user['lastLogin']}'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                        child: Container(
                          height: 30,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              await activeUser(user['_id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 181, 0, 100),
                            ),
                            child: Text(
                              "Accept",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                        child: Container(
                          height: 30,
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () async {
                              await removeUser(user['_id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              "Remove",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
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
  List<Widget> buildInactiveUserWidget(
      List<dynamic> inactiveuserData, Function(String) activeUser) {
    return inactiveuserData.map((user) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
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
                          await activeUser(user['_id']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 181, 0, 100),
                        ),
                        child: Text(
                          "Active",
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

  List<Widget> buildActiveUserWidget(
      List<dynamic> userData, Function(String) removeUser) {
    return userData.map((user) {
      return Column(
        children: [
          //  if (getdata)
          // SizedBox(
          //   height: 1,
          //   child: Center(child: LinearProgressIndicator(color: Colors.pink)),
          // ) else
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 70, 70, 70),
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
                          await removeUser(user['_id']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 181, 0, 100),
                        ),
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
}
