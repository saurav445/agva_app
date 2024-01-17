// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_const, unused_import, library_private_types_in_public_api, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:agva_app/Screens/DeviceList.dart';
import 'package:agva_app/Screens/projects.dart';
import 'package:flutter/material.dart';

class Hospitals extends StatefulWidget {
  final String hospitalName;
  Hospitals({required this.hospitalName});

  @override
  _HospitalsState createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  late String hospitalName;

  @override
  void initState() {
    super.initState();
    hospitalName = widget.hospitalName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 30,
          left: 30,
          top: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.hospitalName,
              style: TextStyle(
                fontFamily: 'Avenir',
                color: Color.fromARGB(255, 218, 218, 218),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Projects(),
                  ),
                );
              },
              child: Container(
                height: 120,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
   color: Color.fromARGB(255, 65, 65, 65),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hospitalName,
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'ANSARI NAGAR, DELHI',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35, top: 30),
                        child: Container(
                          width: 100,
                          child: Image.asset("assets/images/hospital.png"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  // color: Colors.white,
                  ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'AgVa',
                  style: TextStyle(
                    color: Color.fromARGB(255, 157, 0, 86),
                    fontSize: 50,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: Text(
                'HOME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: Text(
                'PROFILE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.devices_other, color: Colors.white),
              title: Text(
                'DEVICES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.circle, color: Colors.white),
              title: Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: Text(
                'SETTINGS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
