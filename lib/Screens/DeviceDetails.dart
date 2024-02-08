// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:agva_app/Screens/DeviceAbout.dart';
import 'package:agva_app/Screens/MonitorData.dart';
import 'package:agva_app/config.dart';
import 'package:agva_app/widgets/Tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Service/SocketService.dart';
import 'LiveView.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceDetails extends StatefulWidget {
  final String deviceId;
  final SocketServices socketService;
  final String wardNo;
  final String deviceType;
  final String message;
  final String hospitalName;
  final String bioMed;
  final String departmentName;
  final String aliasName;

  const DeviceDetails(
    this.deviceId,
    this.socketService,
    this.wardNo,
    this.deviceType,
    this.message,
    this.hospitalName,
    this.bioMed,
    this.departmentName,
    this.aliasName,
  );

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  late SocketServices socketService;
  bool isAddedToFocus = false;
  // bool isDataSaved = false;

  double progress = 0.0;
  int loadingCount = 0;

  bool showLoader = false;

  late String pip = '--';
  late String mVi = '--';
  late String vti = '--';
  late String rr = '--';
  late String pipValue = '--';
  late String mViValue = '--';
  late String vtiValue = '--';
  late String rrValue = '--';
  late String spo2value = '--';
  late String pulseValue = '--';
  late String fiO2 = '--';
  late String fiO2Value = '--';
  late String modeData = '--';
  late String alarmName;
  late String alarmColor;

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    // print('Saved Token: $mytoken');
    return mytoken;
  }

  void toggleFocus() async {
    String? token = await getToken();
    if (token != null) {
      // if (isAddedToFocus) {
      var response = await http.put(
        Uri.parse('$addtofocus/${widget.deviceId}'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['addTofocus'] == false) {
        setState(() {
          isAddedToFocus = !isAddedToFocus;
        });
      }
      print(jsonResponse['addTofocus']);
      // }
    } else {
      print("Token is null");
    }
  }

  @override
  void initState() {
    super.initState();
    toggleFocus();
    // _checkIfDataIsSaved();
    Future.delayed(Duration(seconds: 2), () {
      // Increment counter to 1 after delay
      setState(() {
        loadingCount = 1;
      });
    });
    // widget.socketService.dispose();
    widget.socketService
        .initializeSocket('http://52.64.235.38:8000', widget.deviceId);
    widget.socketService.tilesDataCallBack((
      receivedPipData,
      receivedPipValue,
      receivedMviData,
      receivedMviValue,
      receivedVtiData,
      receivedVtiValue,
      receivedRRData,
      receivedRRValue,
      receivedSpo2Value,
      receivedPulseValue,
      receivedFio2Data,
      receivedFio2Value,
      receivedModeData,
    ) {
      setState(() {
        pip = receivedPipData;
        mVi = receivedMviData;
        vti = receivedVtiData;
        rr = receivedRRData.length >= 5
            ? receivedRRData.substring(0, 5)
            : receivedRRData;
        fiO2 = receivedFio2Data;
        if (receivedPipValue.length > maxLength) {
          pipValue = receivedPipValue.substring(0, maxLength);
        } else {
          pipValue = receivedPipValue;
        }
        if (receivedMviValue.length > maxLength) {
          mViValue = receivedMviValue.substring(0, maxLength);
        } else {
          mViValue = receivedMviValue;
        }
        if (receivedVtiValue.length > maxLength) {
          vtiValue = receivedVtiValue.substring(0, maxLength);
        } else {
          vtiValue = receivedVtiValue;
        }
        if (receivedRRValue.length > maxLength) {
          rrValue = receivedRRValue.substring(0, maxLength);
        } else {
          rrValue = receivedRRValue;
        }
        if (receivedFio2Value.length > maxLength) {
          fiO2Value = receivedFio2Value.substring(0, maxLength);
        } else {
          fiO2Value = receivedFio2Value;
        }
        spo2value = receivedSpo2Value;
        pulseValue = receivedPulseValue;
        modeData = receivedModeData;
      });
      // Delayed loading mechanism
      Future.delayed(Duration(seconds: 1), () {
        // After 1 second, hide the loader and show other widgets
        setState(() {
          showLoader = false;
        });
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  final int maxLength = 4;

  @override
  void dispose() {
    loadingCount = 0;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Patient Details',
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 24,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: Stack(
          children: [
            if (loadingCount == 0)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    LinearProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Connecting server..",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0))
                  ],
                ),
              ),
            if (loadingCount != 0)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                    Text(
                      "SALIM RAZA",
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: MediaQuery.of(context).size.width * 0.07,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    SizedBox(height: 16),

                    //Live tiles
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 89, 89, 89),
                                  ),
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      modeData,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                ResponsiveTileWidget(
                                  // == 'Machine' ? 'M' : 'Resp',
                                  //  == 'Machine' ? pipValue : respiratoryValue,
                                  title: fiO2,
                                  value: fiO2Value,
                                  width: constraints.maxWidth * 0.42,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                ResponsiveTileWidget(
                                  title: vti,
                                  value: vtiValue,
                                  width: constraints.maxWidth * 0.42,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                ResponsiveTileWidget(
                                  title: 'SpO2',
                                  value: spo2value,
                                  width: constraints.maxWidth * 0.42,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                ResponsiveTileWidget(
                                  title: 'EtCo2',
                                  value: spo2value,
                                  width: constraints.maxWidth * 0.42,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ResponsiveTileWidget(
                                  title: pip,
                                  value: pipValue,
                                  width: constraints.maxWidth * 0.42,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                ResponsiveTileWidget(
                                  title: rr,
                                  value: rrValue,
                                  width: constraints.maxWidth * 0.42,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                ResponsiveTileWidget(
                                  title: mVi,
                                  value: mViValue,
                                  width: constraints.maxWidth * 0.42,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                ResponsiveTileWidget(
                                  title: 'PULSE',
                                  value: pulseValue,
                                  width: constraints.maxWidth * 0.42,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                ResponsiveTileWidget(
                                  title: 'ET-CUFF',
                                  value: pulseValue,
                                  width: constraints.maxWidth * 0.42,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    //buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 82, 82, 82),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DeviceAbout(
                                              widget.deviceId,
                                              widget.deviceType),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      "ABOUT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 82, 82, 82),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MonitorData(
                                            widget.deviceId,
                                            widget.wardNo,
                                            widget.message,
                                            widget.hospitalName,
                                            widget.bioMed,
                                            widget.departmentName,
                                            widget.aliasName,
                                          ),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      "MONITOR",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 82, 82, 82),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 15,
                                            child: Image.asset(
                                              "assets/images/active.png",
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LiveView(widget.deviceId),
                                                  // LineGraphApp(),
                                                ),
                                              );
                                            },
                                            // style: TextButton.styleFrom(),
                                            child: Text(
                                              "LIVE VIEW",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.045,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 82, 82, 82),
                                  ),
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(),
                                    child: Text(
                                      "SUPPORT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: isAddedToFocus
                                  ? Color.fromARGB(255, 82, 82, 82)
                                  : Color.fromARGB(255, 174, 34, 104),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
                                width: 170,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  color: Color.fromARGB(255, 82, 82, 82),
                                ),
                                child: TextButton(
                                  onPressed: toggleFocus,
                                  style: TextButton.styleFrom(),
                                  child: Text(
                                    isAddedToFocus
                                        ? "REMOVE FOCUS"
                                        : "ADD TO FOCUS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
