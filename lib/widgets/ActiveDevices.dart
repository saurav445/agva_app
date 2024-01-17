// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ActiveDevices extends StatefulWidget {
  final List<Map<String, dynamic>> deviceList;
  final List<Map<String, dynamic>> deviceData;

  ActiveDevices(this.deviceList, this.deviceData);

  @override
  _ActiveDevicesState createState() => _ActiveDevicesState();
}

class _ActiveDevicesState extends State<ActiveDevices> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.deviceList.asMap().entries.map((entry) {
        final int index = entry.key;
        final Map<String, dynamic> deviceData = entry.value;
        final bool isExpanded = index == _expandedIndex;

        return GestureDetector(
          onTap: () {
            setState(() {
              _expandedIndex = isExpanded ? -1 : index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey,
                  width: 0.2,
                ),
                color: const Color.fromARGB(255, 52, 52, 52),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0.5),
                    color: Color.fromARGB(255, 74, 74, 74),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: isExpanded
                  ? buildExpandedContent(deviceData)
                  : buildCollapsedContent(deviceData),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildCollapsedContent(Map<String, dynamic> deviceData) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 30, right: 16, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    deviceData['message'],
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      color: Color.fromARGB(255, 0, 202, 10),
                      fontSize: 12,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: 10,
                      width: 10,
                      child: Image.asset(
                        getImagePath(deviceData['message']),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 12, right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var info in deviceData['deviceInfo'])
                      Text(
                        '${info['DeviceType']}',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    SizedBox(height: 2),
                    Text(
                      //for Serial Number
                      '',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                             color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 140, bottom: 20),
            child: Container(
              height: 60,
              width: 60,
              child: Image.asset(
                "assets/images/AgVaPro2.png",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExpandedContent(Map<String, dynamic> deviceData) {
    return Column(
      children: [
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Device ID :',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Hospital Name :',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Department Name :',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Doctor Name :',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Alias Name :',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Ward No :',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Bio-Med :',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                              color: Color.fromARGB(255, 218, 218, 218),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var info in deviceData['deviceInfo'])
                      Text(
                        '${info['DeviceId']}',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: 12,
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var info in deviceData['deviceInfo'])
                      Text(
                        '${info['Hospital_Name']}',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: 12,
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var info in deviceData['deviceInfo'])
                      Text(
                        '${info['Department_Name']}',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: 12,
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var info in deviceData['deviceInfo'])
                      Text(
                        '${info['Doctor_Name']}',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: 12,
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var info in deviceData['deviceInfo'])
                      Text(
                        '${info['Alias_Name']}',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: 12,
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var info in deviceData['deviceInfo'])
                      Text(
                        '${info['Ward_No']}',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: 12,
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    for (var info in deviceData['deviceInfo'])
                      Text(
                        '${info['Bio_Med']}',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                          fontSize: 12,
                        ),
                      ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 20),
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
              color: Color.fromARGB(255, 157, 0, 86),
            ),
            child: TextButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DeviceDetails(deviceData),
                //   ),
                // );
              },
              style: TextButton.styleFrom(),
              child: Text(
                "Request",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getImagePath(String message) {
    switch (message) {
      case 'ACTIVE':
        return "assets/images/active.png";
      case 'INACTIVE':
        return "assets/images/inactive.png";
      default:
        return "assets/images/inactive.png";
    }
  }
}
