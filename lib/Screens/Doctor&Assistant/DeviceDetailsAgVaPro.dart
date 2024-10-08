// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures
import 'package:agva_app/Screens/Doctor&Assistant/DoctorDeviceAbout.dart';
import 'package:agva_app/Screens/Doctor&Assistant/PatientList.dart';
import 'package:agva_app/Screens/EventData/MonitorDataMain.dart';
import 'package:agva_app/Screens/Doctor&Assistant/LiveWebView.dart';
import 'package:agva_app/Service/SocketService.dart';
import 'package:agva_app/config.dart';
import 'package:agva_app/widgets/TilesforLandscape.dart';
import 'package:agva_app/widgets/TilesforPortait.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeviceDetailsAgVaPro extends StatefulWidget {
  final String deviceId;
  final SocketServices socketService;
  final String wardNo;
  final String deviceType;
  final String message;
  final String type = '002';

  const DeviceDetailsAgVaPro(this.deviceId, this.socketService, this.wardNo,
      this.deviceType, this.message);

  @override
  State<DeviceDetailsAgVaPro> createState() => _DeviceDetailsAgVaProState();
}

class _DeviceDetailsAgVaProState extends State<DeviceDetailsAgVaPro> {
  late SocketServices socketService;
  bool isLoading = false;
  bool setFocus = false;
  bool currentStatus = false;
  double progress = 0.0;
  int loadingCount = 0;
  bool showLoader = false;
    String? savedsecurityCode;
  late String deviceId;
  List<Map<String, dynamic>> focusedDevices = [];

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

  // String get uri =>
  //     'http://medtap.in/live?code=SBXMH&projectName=Ventilator&DeviceId=';
  String get uri =>
      'http://172.20.10.10:3000/live?code=SBXMH&projectName=Ventilator&DeviceId=';

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');
    return mytoken;
  }

  Future<void> fetchFocusedDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mytoken = prefs.getString('mytoken');

    if (mytoken != null) {
      var response = await http.get(
        Uri.parse(getDeviceForDoctor),
        headers: {
          "Authorization": 'Bearer $mytoken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var data = jsonResponse['data']['data'];
        setState(() {
          isLoading = false;
          focusedDevices = List<Map<String, dynamic>>.from(data)
              .where((device) => device['addTofocus'] == true)
              .toList();
        });
      } else {
        print('Failed to fetch focused devices: ${response.statusCode}');
      }
    } else {
      print("Token is null");
    }
  }

  late String webUrl;

    Future<void> savedevicetype(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('type', type);
        print('saved DeviceCode: $type');
    
  }

  @override
  void initState() {
    super.initState();
print(widget.deviceId);
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loadingCount = 1;
      });
    });
    getFocusStatus();
    savedevicetype(widget.type);
 getUserId().then((securityCode) {
      setState(() {
        savedsecurityCode = securityCode;
      });
    });
    print("I am here");
    widget.socketService.initializeSocket(url, widget.deviceId);
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
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          showLoader = false;
        });
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight
    ]);
  }

    Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? securityCode = prefs.getString('securityCode');
    print('Retrieved savedToken: $securityCode');
    return securityCode;
  }

  void toggleFocus() async {
    setState(() {
      isLoading = true;
    });
    String? jwttoken = await getToken();
    print(widget.deviceId);

    if (jwttoken != null) {
      var response = await http.put(
        Uri.parse('$addtofocus/${widget.deviceId}'),
        headers: {
          "Authorization": 'Bearer $jwttoken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "addTofocus": !currentStatus,
             "userId": savedsecurityCode
        }),
      );
      print('before set $setFocus');
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        var data = jsonResponse['data'];
        var focusStatus = data['addTofocus'];
        setState(() {
          setFocus = focusStatus;
          getFocusStatus();
        });
        print('after set $setFocus');
      } else {
        print('Failed to update focus status: ${response.statusCode}');
      }
    } else {
      print("Token is null");
    }
  }

  void getFocusStatus() async {
    String? token = await getToken();
    print(widget.deviceId);
    if (token != null) {
      var response = await http.get(
        Uri.parse('$getStatus/${widget.deviceId}'),
        headers: {
          "Authorization": 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        var data = jsonResponse['data'];
        var focusStatus = data['addTofocus'];
        setState(() {
          currentStatus = focusStatus;
          isLoading = false;
          print(currentStatus);
        });
      } else {
        print('Failed to get focus status: ${response.statusCode}');
      }
    } else {
      print("Token is null");
    }
  }

  final int maxLength = 4;

  @override
  void dispose() {
    super.dispose();
    loadingCount = 0;
    widget.socketService.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      // DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, 'refresh');
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.person,
                size: 20,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientList(widget.deviceId),
                  ),
                );
              },
            ),
          ],
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Patient Details',
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitLayout(context);
          } else {
            return _buildLandscapeLayout(context);
          }
        }),
      ),
    );
  }

  String getImagePath(message) {
    switch (message) {
      case 'ACTIVE':
        return "assets/images/active.png";
      case 'INATIVE':
        return "assets/images/inactive.png";
      default:
        return "assets/images/inactive.png";
    }
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Stack(
      children: [
        if (loadingCount == 0)
          Column(
            children: [
              SizedBox(
                  height: 1,
                  child: LinearProgressIndicator(color: Colors.pink)),
              Center(
                child: Text("Please wait.. Connecting to server",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 15.0)),
              ),
            ],
          ),
        if (loadingCount != 0)
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Text(
                  "SALIM RAZA",
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontSize: MediaQuery.of(context).size.width * 0.06,
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
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 58, 58, 58),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                    modeData,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            TilesforPortait(
                              title: fiO2,
                              value: fiO2Value,
                              width: constraints.maxWidth * 0.45,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            TilesforPortait(
                              title: vti,
                              value: vtiValue,
                              width: constraints.maxWidth * 0.45,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            TilesforPortait(
                              title: 'SpO2',
                              value: spo2value,
                              width: constraints.maxWidth * 0.45,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            TilesforPortait(
                              title: 'EtCo2',
                              value: '-',
                              width: constraints.maxWidth * 0.45,
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
                            TilesforPortait(
                              title: pip,
                              value: pipValue,
                              width: constraints.maxWidth * 0.45,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            TilesforPortait(
                              title: rr,
                              value: rrValue,
                              width: constraints.maxWidth * 0.45,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            TilesforPortait(
                              title: mVi,
                              value: mViValue,
                              width: constraints.maxWidth * 0.45,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            TilesforPortait(
                              title: 'PULSE',
                              value: pulseValue,
                              width: constraints.maxWidth * 0.45,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            TilesforPortait(
                              title: 'ET-CUFF',
                              value: '-',
                              width: constraints.maxWidth * 0.45,
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
                  padding: EdgeInsets.only(left: 18, right: 18, bottom: 40),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 58, 58, 58),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorDeviceAbout(
                                          widget.deviceId, widget.deviceType),
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 58, 58, 58),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MonitorData(
                                        widget.deviceId,
                                        widget.type
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(),
                                child: Text(
                                  "EVENT DATA",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045,
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 58, 58, 58),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 15,
                                        child: Image.asset(
                                          getImagePath(widget.message),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (widget.message == 'ACTIVE') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewPage(
                                                        widget.deviceId,
                                                        uri: uri,
                                                      )
// SocketGraphPage(
// widget.deviceId),
                                                  // LiveView(widget.deviceId),
// LineGraphApp(),
                                                  ),
                                            );
                                          } else {
                                            final snackBar = SnackBar(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 65, 65, 65),
                                              content: Text(
                                                "Device in Standby",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              action: SnackBarAction(
                                                textColor: Colors.black,
                                                backgroundColor: Colors.white,
                                                label: 'OK',
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 58, 58, 58),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AssistantList(widget.deviceId)));
                                  final snackBar = SnackBar(
                                    backgroundColor:
                                        const Color.fromARGB(255, 65, 65, 65),
                                    content: Text(
                                      "Currently Unavailable",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    action: SnackBarAction(
                                      textColor: Colors.black,
                                      backgroundColor: Colors.white,
                                      label: 'OK',
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                style: TextButton.styleFrom(),
                                child: Text(
                                  "SUPPORT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (isLoading)
                        SizedBox(
                          height: 0.5,
                          child: LinearProgressIndicator(
                            color: Color.fromARGB(255, 174, 34, 104),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: currentStatus
                                ? Color.fromARGB(255, 174, 34, 104)
                                : Color.fromARGB(255, 58, 58, 58),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 58, 58, 58),
                              ),
                              child: TextButton(
                                  onPressed: toggleFocus,
                                  style: TextButton.styleFrom(),
                                  child: Text(
                                    currentStatus
                                        ? "REMOVE FOCUS"
                                        : "ADD TO FOCUS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045,
                                    ),
                                  )),
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
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Stack(
      children: [
        if (loadingCount == 0)
          Column(
            children: const [
              SizedBox(
                  height: 0.5,
                  child: LinearProgressIndicator(color: Colors.pink)),
              SizedBox(
                height: 20,
              ),
              Text("Connecting server..",
                  style: TextStyle(color: Colors.white, fontSize: 20.0))
            ],
          ),
        if (loadingCount != 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.035,
              ),
              Text(
                "SALIM RAZA",
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontSize: MediaQuery.of(context).size.width * 0.02,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
//Live tiles
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.15,
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
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                              ),
                            ),
                          ),
                          TilesforLandscape(
                            title: rr,
                            value: rrValue,
                          ),
                          TilesforLandscape(
                            title: mVi,
                            value: mViValue,
                          ),
                          TilesforLandscape(
                            title: 'PULSE',
                            value: pulseValue,
                          ),
                          TilesforLandscape(
                            title: 'ET-CUFF',
                            value: '-',
                          ),
                        ],
                      ), // ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TilesforLandscape(
                            title: fiO2,
                            value: fiO2Value,
                          ),
                          TilesforLandscape(
                            title: pip,
                            value: pipValue,
                          ),
                          TilesforLandscape(
                            title: vti,
                            value: vtiValue,
                          ),
                          TilesforLandscape(
                            title: 'SpO2',
                            value: spo2value,
                          ),
                          TilesforLandscape(
                            title: 'EtCo2',
                            value: '-',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 58, 58, 58),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DoctorDeviceAbout(
                                        widget.deviceId, widget.deviceType),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(),
                              child: Text(
                                "ABOUT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 58, 58, 58),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MonitorData(
                                      widget.deviceId,
                                              widget.type
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
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 58, 58, 58),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      child: Image.asset(
                                        getImagePath(widget.message),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (widget.message == 'ACTIVE') {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   LiveView(widget.deviceId),
// // LineGraphApp(),
//                                             ),
//                                           );
                                        } else {
                                          final snackBar = SnackBar(
                                            content: Center(
                                              child: const Text(
                                                "Device in StandBy",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            action: SnackBarAction(
                                              label: '',
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },

// style: TextButton.styleFrom(),
                                      child: Text(
                                        "LIVE VIEW",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 58, 58, 58),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(),
                              child: Text(
                                "SUPPORT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: currentStatus
                                  ? Color.fromARGB(255, 174, 34, 104)
                                  : Color.fromARGB(255, 82, 82, 82),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.14,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  color: Color.fromARGB(255, 58, 58, 58),
                                ),
                                child: TextButton(
                                  onPressed: toggleFocus,
                                  style: TextButton.styleFrom(),
                                  child: Text(
                                    currentStatus
                                        ? "REMOVE FOCUS"
                                        : "ADD TO FOCUS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
      ],
    );
  }
}
