// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:agva_app/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AssistantList extends StatefulWidget {
  final String deviceId;
  AssistantList(this.deviceId);

  @override
  State<AssistantList> createState() => _AssistantListState();
}

class _AssistantListState extends State<AssistantList>
    with SingleTickerProviderStateMixin {
  late String deviceId;
  List<dynamic> assistanlist = [];
  List<dynamic> assignedUser = [];
  String updateUser = 'Assistant List';
  bool isLoading = true;
  bool getdata = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
  ]);
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    getAssistantList();
    print(widget.deviceId);
  }

  void _handleTabSelection() {
    setState(() {
      switch (_tabController.index) {
        case 0:
          updateUser = 'Assistant List';
          getAssistantList();
          break;
        case 1:
          updateUser = 'Assigned';
          getAssignedUser();
          break;
      }
    });
  }

  assign(data) async {
    var userid = data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');

    if (mytoken != null) {
      var response = await http.post(
        Uri.parse(assignDevice),
        headers: {
          "Authorization": 'Bearer $mytoken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"deviceId": widget.deviceId, "assistantId": userid}),
      );
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: Text(
                "Assigned",
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        );

        getAssistantList();
      } else {
        print('Failed to update Approved status: ${response.body}');
      }
    } else {
      print("Token is null");
    }
  }

  unassign(data) async {
    var userid = data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    print(userid);
    if (mytoken != null) {
      var response = await http.delete(
        Uri.parse('$revokeAssign/$userid'),
        headers: {
          "Authorization": 'Bearer $mytoken',
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Removed",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          },
        );

        getAssignedUser();
      } else {
        print('Failed to remove device assign: ${response.body}');
      }
    } else {
      print("Token is null");
    }
  }

  void getAssistantList() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    if (mytoken != null) {
      var response = await http.get(
        Uri.parse(getAssignedList),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusCode'] == 200) {
        // print(jsonResponse);
        setState(() {
          assistanlist = jsonResponse['data'];
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

  void getAssignedUser() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    if (mytoken != null) {
      var response = await http.get(
        Uri.parse(getAssignedAssistandList),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusCode'] == 200) {
        print(jsonResponse);
        setState(() {
          assignedUser = jsonResponse['data'];
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

  List<Widget> buildActiveUserWidgets(List<dynamic> assistanlist, assign) {
    return assistanlist.map((user) {
      bool isAssigned = user['isAssigned'] ??
          false;
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
                  if (!isAssigned) // Render button only if not assigned
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                      child: Container(
                        height: 30,
                        width: 100,
                        child: StatefulBuilder(builder: (context, setState) {
                          return ElevatedButton(
                            onPressed: () => assign(user['_id']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 181, 0, 100),
                            ),
                            child: Text(
                              isLoading ? 'Processing' : 'Assign',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
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

  List<Widget> buildAssignedUserWidgets(List<dynamic> assignedUser, unassign) {
    return assignedUser.map((user) {
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
                          onPressed: () => unassign(user['_id']),
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
            "Assign Device",
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
                text: 'Assistant List',
              ),
              Tab(
                text: 'Assigned',
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
                else if (assistanlist.isEmpty)
                  Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 3),
                      Text('No Data Found'),
                    ],
                  )
                else
                  Column(
                    children: buildActiveUserWidgets(assistanlist, assign),
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
                else if (assignedUser.isEmpty)
                  Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 3),
                      Text('No Data Found'),
                    ],
                  )
                else
                  Column(
                    children: buildAssignedUserWidgets(assignedUser, unassign),
                  ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
