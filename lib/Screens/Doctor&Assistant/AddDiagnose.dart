import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';

class AddDiagnose extends StatefulWidget {
  final String UHID;
  AddDiagnose(this.UHID);

  @override
  State<AddDiagnose> createState() => _AddDiagnoseState();
}

class _AddDiagnoseState extends State<AddDiagnose> {
  late String UHID;
  List<dynamic> userData = [];

  bool isLoading = true;

  void initState() {
    super.initState();
    dateInput.text = "";
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    print(widget.UHID);
  }

  TextEditingController medicineController = TextEditingController();
  TextEditingController procedureController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  void addDiagnoseData() async {
    String? token = await getToken();
    var regBody = {
      "medicine": medicineController.text,
      "procedure": procedureController.text,
      "others": otherController.text,
    };

    var response = await http.post(
      Uri.parse('$addDiagnoseDetails/${widget.UHID}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Add Events'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
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
                hintText: widget.UHID,
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: medicineController,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.medication,
                  color: Colors.white70,
                ),
                hintText: 'Events',
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(
              height: 40,
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
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    print(pickedDate);
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(formattedDate);
                    setState(() {
                      dateInput.text = formattedDate;
                    });
                  }
                }),
            SizedBox(
              height: 40,
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
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  print(pickedTime);
                  String formattedTime = pickedTime.format(context);
                  print(formattedTime);
                  setState(() {
                    timeInput.text = formattedTime;
                  });
                }
              },
            ),
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
    );
  }
}
