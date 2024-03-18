// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, library_private_types_in_public_api, avoid_print, prefer_final_fields, unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agva_app/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPatientData extends StatefulWidget {
  final String uhid;
  final String deviceId;
  final String userId;
  
  AddPatientData(this.uhid, this.deviceId, this.userId, {super.key});

  @override
  _AddPatientDataState createState() => _AddPatientDataState();
}

class _AddPatientDataState extends State<AddPatientData> {
  late String uhid;
  late String deviceId;
  late String userId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  List<PlatformFile>? _paths;
  bool _isLoading = false;
  bool _userAborted = false;
  bool first = false;
  bool _validate = false;

  final enterwardnoController = TextEditingController();
  final enterpatientnameController = TextEditingController();
  final enterpatientageController = TextEditingController();
  final enterheightincmController = TextEditingController();
  final enterweightinkgController = TextEditingController();
  final enterdrnameController = TextEditingController();
  final enterdasageController = TextEditingController();
  final enteruhidController = TextEditingController();
  final enterdeviceIdController = TextEditingController();

  String? get uploadURL =>
      '$patientFileupload/${widget.deviceId}/${enteruhidController.text}';

  void clearText() {
    enterwardnoController.clear();
    enterpatientnameController.clear();
    enterpatientageController.clear();
    enterheightincmController.clear();
    enterweightinkgController.clear();
    enterdrnameController.clear();
    enterdasageController.clear();
    enteruhidController.clear();
    enterdeviceIdController.clear();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    print(widget.uhid);
    print(widget.deviceId);
    print(widget.userId);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mytoken');
  }

  void addPatientdata() async {
    String? token = await getToken();
    if (token != null) {
      var regBody = {
        "UHID": widget.uhid ?? enteruhidController.text,
        "age": enterpatientageController.text,
        "deviceId": widget.deviceId,
        "doctor_name": enterdrnameController.text,
        "dosageProvided": enterdasageController.text,
        "height": enterheightincmController.text,
        "patientName": enterpatientnameController.text,
        "ward_no": enterwardnoController.text,
        "weight": enterweightinkgController.text
      };

      var response = await http.put(
        Uri.parse('$updatePatientDetails/${widget.userId}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $token',
        },
        body: jsonEncode(regBody),
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['statusValue'] == 'SUCCESS') {
        showDialog(
          barrierLabel: "Data submission",
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Data submitted successfully',
                style: TextStyle(fontSize: 20),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    print("CHECKED");
                    Navigator.pop(context);
                    clearText();
                    setState(() {
                      _paths = null;
                    });
                  },
                ),
              ],
            );
          },
        );

        print('Patient data added successfully');
      } else {
        print(response.statusCode);
      }
    }
  }

  void uploadFilewithuhid(List<PlatformFile> files) async {
    for (var file in files) {
      if (file.path != null) {
        // setState(() {
        //   _isLoading = true;
        // });
        var request = http.MultipartRequest(
          "POST",
          Uri.parse('$patientFileupload/${widget.deviceId}/${widget.uhid}'),
        );
        print(widget.userId);
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path!,
        ));

        var response = await request.send();
        if (response.statusCode == 200) {
          print(response.statusCode);
          var responseData = await response.stream.bytesToString();
          print("File uploaded successfully");
          setState(() {
            _isLoading = false;
          });
          print("Server Response: $responseData");
        } else {
          print("Failed to upload file. Status Code: ${response.statusCode}");
        }
      } else {
        print("File path is null");
      }
    }
  }

  void uploadFilewithoutuhid(List<PlatformFile> files) async {
    for (var file in files) {
      if (file.path != null) {
        // setState(() {
        //   _isLoading = true;
        // });
        var request = http.MultipartRequest(
          "POST",
          Uri.parse(
              '$patientFileupload/${widget.deviceId}/${enteruhidController.text}'),
        );
        print(widget.userId);
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path!,
        ));

        var response = await request.send();
        if (response.statusCode == 200) {
          print(response.statusCode);
          var responseData = await response.stream.bytesToString();
          print("File uploaded successfully");
          setState(() {
            _isLoading = false;
          });
          print("Server Response: $responseData");
        } else {
          print("Failed to upload file. Status Code: ${response.statusCode}");
        }
      } else {
        print("File path is null");
      }
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

//export
  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _fileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldMessengerKey;
    return Scaffold(
        backgroundColor: Colors.black,
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Add Patient Details",
          ),
          backgroundColor: Colors.black,
        ),
        body: Stack(alignment: Alignment.center, children: [
          SingleChildScrollView(
              child: Container(
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                height: 20,
              ),
              if (widget.uhid.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: TextFormField(
                    controller: enteruhidController,
                    style: TextStyle(color: Colors.white70),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white70,
                      ),
                      hintText: 'Enter UHID',
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(color: Colors.white70),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white70,
                      ),
                      hintText: widget.uhid,
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
                  readOnly: true,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.important_devices,
                      color: Colors.white70,
                      size: 20,
                    ),
                    hintText: widget.deviceId,
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
                  controller: enterpatientnameController,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    icon: FaIcon(
                      FontAwesomeIcons.person,
                      size: 20,
                    ),
                    hintText: 'Enter Patient Name',
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
                  controller: enterpatientageController,
                  style: TextStyle(color: Colors.white70),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: FaIcon(
                      FontAwesomeIcons.person,
                      size: 20,
                    ),
                    hintText: 'Enter Patient Age',
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
                  controller: enterheightincmController,
                  style: TextStyle(color: Colors.white70),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: FaIcon(
                      FontAwesomeIcons.person,
                      size: 20,
                    ),
                    hintText: 'Enter Height in cm',
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
                  controller: enterweightinkgController,
                  style: TextStyle(color: Colors.white70),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: FaIcon(
                      FontAwesomeIcons.person,
                      size: 20,
                    ),
                    hintText: 'Enter Weight in kg',
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
                  controller: enterdasageController,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.medical_information,
                      color: Colors.white70,
                    ),
                    hintText: 'Dosage Provided',
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
                  controller: enterdrnameController,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white70,
                    ),
                    hintText: 'Enter Dr. Name',
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
                  controller: enterwardnoController,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.cabin,
                      color: Colors.white70,
                    ),
                    hintText: 'Enter Ward No.',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              if (widget.uhid.isNotEmpty)
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    setState(() {
                      _isLoading = true;
                    });

                    if (result != null) {
                      setState(() {
                        _paths = result.files;
                        uploadFilewithuhid(result.files);
                      });
                    } else {}
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Upload Documents",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                )
              else ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  setState(() {
                    _isLoading = true;
                  });

                  if (result != null) {
                    setState(() {
                      _paths = result.files;
                      uploadFilewithoutuhid(result.files);
                    });
                  } else {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  "Upload Documents",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
                Builder(
                  builder: (BuildContext context) => _isLoading
                      ? Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: const CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _userAborted
                          ? Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: SizedBox(
                                      height: 10,
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.error_outline,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        title: const Text(
                                          'User has aborted the dialog',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : _paths != null
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      // vertical: 1.0,
                                      horizontal: 30),
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: ListView.builder(
                                    itemCount:
                                        _paths != null && _paths!.isNotEmpty
                                            ? _paths!.length
                                            : 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final bool isMultiPath =
                                          _paths != null && _paths!.isNotEmpty;
                                      final String name = 'File:' +
                                          (isMultiPath
                                              ? _paths!
                                                  .map((e) => e.name)
                                                  .toList()[index]
                                              : _fileName ?? '...');

                                      Upload(File img) async {
                                        var uri = Uri.parse(uploadURL!);
                                        var request =
                                            http.MultipartRequest("POST", uri);
                                        request.files
                                            .add(http.MultipartFile.fromBytes(
                                          "file",
                                          img.readAsBytesSync(),
                                          filename: "Photo.jpg",
                                        ));

                                        var response = await request.send();
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        print(response.statusCode);
                                        response.stream
                                            .transform(utf8.decoder)
                                            .listen((value) {
                                          print(value);
                                        });
                                      }

                                      return ListTile(
                                        title: Text(
                                          name,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 22, 0),
                child: Container(
                  height: 45,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 181, 0, 100),
                      
                          ),
                  child: TextButton(
                    onPressed: addPatientdata,
                    style: TextButton.styleFrom(),
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ]),
          )),
        ]));
  }
}
