// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_build_context_synchronously, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPatientData extends StatefulWidget {
  @override
  _AddPatientDataState createState() => _AddPatientDataState();
}

class _AddPatientDataState extends State<AddPatientData> {
  bool first = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController hospitalNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController specialityController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Patient Details",
          ),
          backgroundColor: Colors.black,
          toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        ),
        body: Stack(alignment: Alignment.center, children: [
          SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                child: Column(

                  
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                            hintText: 'Enter UHID',
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
                              Icons.important_devices,
                              color: Colors.white70,
                            ),
                            hintText: 'Enter DeviceID',
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
                          controller: designationController,
                          style: TextStyle(color: Colors.white70),
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
                          controller: departmentController,
                          style: TextStyle(color: Colors.white70),
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
                          controller: emailController,
                          style: TextStyle(color: Colors.white70),
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
                          style: TextStyle(color: Colors.white70),
                          decoration: InputDecoration(
                            icon: FaIcon(
                              FontAwesomeIcons.hospital,
                              size: 20,
                            ),
                            hintText: 'Enter Hospital Name',
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
                            onPressed: () {},
                            style: TextButton.styleFrom(),
                            child: Text(
                              "SUBMIT",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ])),
          )
        ]));
  }
}
