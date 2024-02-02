// ignore_for_file: must_be_immutable, prefer_const_constructors
import 'package:agva_app/Screens/DeviceAbout.dart';
import 'package:agva_app/Screens/MonitorData.dart';
import 'package:agva_app/widgets/Tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Service/SocketService.dart';
import 'LiveView.dart';

class DeviceDetails extends StatefulWidget {
  final String deviceId;
  late String wardNo;
  late String deviceType;
  late String message;
  late String hospitalName;
  late String bioMed;
  late String departmentName;
  late String aliasName;

  DeviceDetails(this.deviceId, this.wardNo, this.deviceType, this.message,
      this.hospitalName, this.bioMed, this.departmentName, this.aliasName);

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  // late List<String> focusedDevices = [];
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

  @override
  void initState() {
    super.initState();
    SocketServices()
        .initializeSocket('http://192.168.92.71:8000', widget.deviceId);
    SocketServices socketService = SocketServices();
    socketService.tilesDataCallBack((
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
      receivedModeData
    ) {
      setState(() {
        pip = receivedPipData;
        mVi = receivedMviData;
        vti = receivedVtiData;
        rr = receivedRRData.substring(0, 5);
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
    });
    // getFocusedDevices();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
    ]);
  }

  final int maxLength = 4;

  @override
  void dispose() {
    SocketServices()
        .initializeSocket('http://192.168.92.71:8000', widget.deviceId);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isInFocus = focusedDevices.contains(widget.deviceId);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            // widget.deviceId,
            'Details',
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 24,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                  ),
                  Text(
                    "PT. SALIM RAZA",
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WARD NO. ${widget.wardNo}',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              '65 KG',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'BED NO. 115',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              '25 YEARS',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                color: Color.fromARGB(255, 218, 218, 218),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              
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
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
                                width: MediaQuery.of(context).size.width * 0.42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 38, 128, 158),
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
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              ResponsiveTileWidget(
                                // == 'Machine' ? 'M' : 'Resp',
              //  == 'Machine' ? pipValue : respiratoryValue,
                                title: fiO2,
                                value: fiO2Value,
                                width: constraints.maxWidth * 0.42,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              ResponsiveTileWidget(
                                title: vti,
                                value: vtiValue,
                                width: constraints.maxWidth * 0.42,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              ResponsiveTileWidget(
                                title: 'SpO2',
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
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              ResponsiveTileWidget(
                                title: rr,
                                value: rrValue,
                                width: constraints.maxWidth * 0.42,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              ResponsiveTileWidget(
                                title: mVi,
                                value: mViValue,
                                width: constraints.maxWidth * 0.42,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.015,
                              ),
                              ResponsiveTileWidget(
                                title: 'PULSE',
                                value: pulseValue,
                                width: constraints.maxWidth * 0.42,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  //buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 82, 82, 82),
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
                                              ),
                                            );
              
                                          },
                                          style: TextButton.styleFrom(),
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
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(255, 174, 34, 104),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.065,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                                color: Color.fromARGB(255, 82, 82, 82),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  // updateFocusList(widget.deviceId);
                                },
                                style: TextButton.styleFrom(),
                                child: Text(
                                  // isInFocus
                                  //     ? "REMOVE FROM FOCUS"
                                  //     :
                                  "ADD TO FOCUS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width * 0.045,
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
