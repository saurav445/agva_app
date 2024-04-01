// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  // Check Box Variables
  bool hypertension = false;
  bool diabetes = false;

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
    //pass uhid
    uhid = widget.uhid;
    print(uhid);
  }

  TextEditingController eventController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
//accessing token from sharedpreference
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

// get data from backend
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
      Navigator.pop(context, 'refresh'); // Refresh on backpress
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
                    DateTime? pickedDate = await showDatePicker(
                    
                    
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100));
                        builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark( 
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    surface: Colors.pink,
                    onSurface: Colors.yellow,
                    ),
                dialogBackgroundColor:Colors.blue[900],
              ),
              child: child,
            );
          };

                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate);
                      setState(() {
                        dateInput.text = formattedDate;
                      });
                    }
                  }
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
                height: 30,
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
      ),
    );
  }
}
// enum SingingCharacter { Hypertension, Diabetes }

// class RadioExample extends StatefulWidget {
//   const RadioExample({super.key});

//   @override
//   State<RadioExample> createState() => _RadioExampleState();
// }

// class _RadioExampleState extends State<RadioExample> {
//   SingingCharacter? _character = SingingCharacter.Hypertension;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         ListTile(
//           title: const Text('Hypertension'),
//           leading: Radio<SingingCharacter>(
//             value: SingingCharacter.Hypertension,
//             groupValue: _character,
//             onChanged: (SingingCharacter? value) {
//               setState(() {
//                 _character = value;
//               });
//             },
//           ),
//         ),
//         ListTile(
//           title: const Text('Diabetes'),
//           leading: Radio<SingingCharacter>(
//             value: SingingCharacter.Diabetes,
//             groupValue: _character,
//             onChanged: (SingingCharacter? value) {
//               setState(() {
//                 _character = value;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
