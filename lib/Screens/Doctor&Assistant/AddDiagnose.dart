// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

class AddDiagnose extends StatefulWidget {
  final String uhid;
  AddDiagnose(this.uhid);

  @override
  State<AddDiagnose> createState() => _AddDiagnoseState();
}

class _AddDiagnoseState extends State<AddDiagnose> {
  late String uhid;
  // List<TextEditingController> eventControllers = [];
  // List<TextEditingController> diagnosisControllers = [];

  // int moretextfield = 0;
  // int adddiag = 0;
  bool isLoading = true;

  void initState() {
    super.initState();
    dateInput.text = "";
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    uhid = widget.uhid;
    print(uhid);
  }

  TextEditingController eventController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  void addDiagnoseData() async {
    String? token = await getToken();
    // List<String> eventTexts =
    //     eventControllers.map((controller) => controller.text).toList();
    // List<String> diagnosisTexts =
    //     diagnosisControllers.map((controller) => controller.text).toList();

    var regBody = {
      "medicine": eventController.text,
      "procedure": diagnosisController.text,
      "others": otherController.text,
    };

    var response = await http.post(
      Uri.parse('$addDiagnoseDetails/$uhid'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $token',
      },
      body: jsonEncode(regBody),
    );
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    if (response.statusCode == 200) {
      Navigator.pop(context, 'refresh');
      print(jsonResponse['data']);
      print('Patient data added successfully');
    } else {
      print("Something Went Wrong");
    }
  }

  // void addMedicine() {
  //   setState(() {
  //     moretextfield++;
  //     eventControllers.add(TextEditingController());
  //   });
  // }

  // void removeMedicine() {
  //   setState(() {
  //     moretextfield--;
  //   });
  // }

  // void addDiagnosis() {
  //   setState(() {
  //     adddiag++;
  //     diagnosisControllers.add(TextEditingController());
  //   });
  // }

  // void removeDiagnosis() {
  //   setState(() {
  //     adddiag--;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Add Events'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              TextFormField(
                readOnly: true,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white70,
                  ),
                  hintText: uhid,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: eventController,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.event,
                    color: Colors.white70,
                  ),
                  // suffixIcon: IconButton(
                  //     icon: Icon(Icons.add), onPressed: addDiagnosis),
                  hintText: 'Enter Event',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              // for (int i = 0; i < eventControllers.length; i++)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 30),
              //     child: TextFormField(
              //       controller: eventControllers[i],
              //       style: TextStyle(color: Colors.white70),
              //       decoration: InputDecoration(
              //         icon: Icon(
              //           Icons.medication,
              //           color: Colors.white70,
              //         ),
              //         suffixIcon: IconButton(
              //             icon: Icon(Icons.remove), onPressed: removeMedicine),
              //         hintText: 'Enter Event',
              //         hintStyle: TextStyle(color: Colors.white70),
              //       ),
              //     ),
              //   ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: diagnosisController,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.medication,
                    color: Colors.white70,
                  ),
                  // suffixIcon: IconButton(
                  //     icon: Icon(Icons.add), onPressed: addDiagnosis),
                  hintText: 'Enter Diagnosis',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              ),
              // for (int i = 0; i < diagnosisControllers.length; i++)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 30),
              //     child: TextFormField(
              //       controller: diagnosisControllers[i],
              //       style: TextStyle(color: Colors.white70),
              //       decoration: InputDecoration(
              //         icon: Icon(
              //           Icons.medication,
              //           color: Colors.white70,
              //         ),
              //         suffixIcon: IconButton(
              //             icon: Icon(Icons.remove), onPressed: removeMedicine),
              //         hintText: 'Diagnosis',
              //         hintStyle: TextStyle(color: Colors.white70),
              //       ),
              //     ),
              //   ),
              SizedBox(
                height: 30,
              ),
              TextField(
                readOnly: true,
                controller: dateInput,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.date_range,
                    color: Colors.white70,
                  ),
                  hintText: 'Date',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                onTap: () async {
                  // date picker logic
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                readOnly: true,
                controller: timeInput,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.access_time,
                    color: Colors.white70,
                  ),
                  hintText: 'Time',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                onTap: () async {
                  // time picker logic
                },
              ),
              // SizedBox(
              //   height: 50,
              // ),
              // Row(
              //   children: [
              //     Container(
              //       height: 40,
              //       width: MediaQuery.of(context).size.width * 0.35,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5),
              //         color: const Color.fromARGB(255, 89, 89, 89),
              //       ),
              //       child: TextButton(
              //         onPressed: addMedicine,
              //         style: TextButton.styleFrom(),
              //         child: Text(
              //           "Add Event",
              //           style: TextStyle(color: Colors.white, fontSize: 15),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 30,
              //     ),
              //     Container(
              //       height: 40,
              //       width: MediaQuery.of(context).size.width * 0.35,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(5),
              //         color: const Color.fromARGB(255, 89, 89, 89),
              //       ),
              //       child: TextButton(
              //         onPressed: addDiagnosis,
              //         style: TextButton.styleFrom(),
              //         child: Text(
              //           "Add Diagnosis",
              //           style: TextStyle(color: Colors.white, fontSize: 15),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                child: Container(
                  height: 45,
                  width: 250,
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
                    onPressed: addDiagnoseData,
                    style: TextButton.styleFrom(),
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
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
