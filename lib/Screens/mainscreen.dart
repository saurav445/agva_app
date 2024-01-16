// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_const, unused_import, library_private_types_in_public_api, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:flutter/material.dart';
import '../widgets/ActiveDevices.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
              'HOME',
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
            Container(
              height: 140,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromARGB(255, 225, 92, 156),
                    Color.fromARGB(255, 238, 44, 76),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      'DEVICES',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 65, top: 30),
                      child: Container(
                        height: 120,
                        width: 120,
                        child: Image.asset("assets/images/deviceimage.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 140,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromARGB(255, 50, 50, 50),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      'ALARMS',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 0),
                      child: Container(
                          height: 150,
                          width: 150,
                          child: Image.asset("assets/images/alarmimage.png")),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 140,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromARGB(255, 173, 25, 25),
                    Color.fromARGB(255, 7, 7, 7),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      'FOCUS',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 87, top: 0),
                        child: Container(
                            width: 130,
                            child:
                                Image.asset("assets/images/focusimage.png"))),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 140,
              width: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromARGB(255, 92, 74, 251),
                    Color.fromARGB(255, 30, 30, 30),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'AI',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 218, 218, 218),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'COMING SOON..',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            color: Color.fromARGB(255, 218, 218, 218),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 0),
                      child: Container(
                        height: 180,
                        width: 180,
                        child: Image.asset("assets/images/aiimage.png"),
                      ),
                    ),
                  ],
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
