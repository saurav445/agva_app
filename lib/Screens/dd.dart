import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDevices extends StatefulWidget {
  @override
  _MyDevicesState createState() => _MyDevicesState();
}

class _MyDevicesState extends State<MyDevices> {
  List<String> focusedDevices = [];

  @override
  void initState() {
    super.initState();
    getFocusedDevices();
  }

  Future<void> getFocusedDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      focusedDevices = prefs.getStringList('focusedDevices') ?? [];
    });
  }

  Future<void> updateFocusList(String deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (focusedDevices.contains(deviceId)) {
        focusedDevices.remove(deviceId);
      } else {
        focusedDevices.add(deviceId);
      }
    });

    await prefs.setStringList('focusedDevices', focusedDevices);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            child: Column(
              children: [
                Text(
                  'My Devices',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    color: Color.fromARGB(255, 218, 218, 218),
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                for (String deviceId in focusedDevices)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 69, 174, 34),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              deviceId,
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                updateFocusList(deviceId);
                              },
                              child: Text('Remove from Focus'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
