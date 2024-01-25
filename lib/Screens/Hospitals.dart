// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'DeviceList.dart';

class Hospitals extends StatefulWidget {
  final String hospitalName;

  Hospitals({required this.hospitalName});

  @override
  _HospitalsState createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  late String hospitalName;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    hospitalName = widget.hospitalName;
  }

  List<String> projectsForHospital = [
    'AgVa PRO',
    'Suction',
  ];

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
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HOSPITALS',
              style: TextStyle(
                fontFamily: 'Avenir',
                color: Color.fromARGB(255, 218, 218, 218),
                fontSize: MediaQuery.of(context).size.width * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.13,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromARGB(255, 65, 65, 65),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                fontSize: MediaQuery.of(context).size.width * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Text(
                              'ANSARI NAGAR, DELHI',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize: MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only( top: 30),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Image.asset("assets/images/hospital.png"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            if (isExpanded)
              ...projectsForHospital.map(
                (project) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeviceList(),
                        ),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color.fromARGB(255, 135, 135, 135),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:30),
                            child: Text(
                              project,
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 228, 228, 228),
                                fontSize: MediaQuery.of(context).size.width * 0.06,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Image.asset(
                                getImagePath(project),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    fontSize: MediaQuery.of(context).size.width * 0.1,
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
                  fontSize: MediaQuery.of(context).size.width * 0.035,
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
                  fontSize: MediaQuery.of(context).size.width * 0.035,
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
                  fontSize: MediaQuery.of(context).size.width * 0.035,
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
                  fontSize: MediaQuery.of(context).size.width * 0.035,
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
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  String getImagePath(project) {
    switch (project) {
      case 'AgVa PRO':
        return "assets/images/deviceimage.png";
      case 'Suction':
        return "assets/images/suctionimage.png";
      default:
        return "assets/images/inactive.png";
    }
  }
}
