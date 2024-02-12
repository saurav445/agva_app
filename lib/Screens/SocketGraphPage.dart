import 'package:flutter/material.dart';
import 'package:agva_app/Service/SocketService.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:fl_chart/fl_chart.dart';

class SocketGraphPage extends StatefulWidget {
  final String deviceId;
  const SocketGraphPage(this.deviceId, {super.key});
  @override
  _SocketGraphPageState createState() => _SocketGraphPageState();
}

class _SocketGraphPageState extends State<SocketGraphPage> {
  late IO.Socket socket;
  List<int> fifoLimit = [350];
  List<Color> lineColors = [Colors.black, Colors.white];

  bool isFirstTime = false;
  int xVal = 0;
  Color? newColor;
  bool freezeGraph = false;

  late List<FlSpot> chartData;
  late List<FlSpot> chartDataVolume;
  late List<FlSpot> chartDataFlow;

  String selectedMenu = 'GRAPHS';
  late String deviceId;
  late String modeData = '-';
  late List<String> observedData = [];
  late List<String> setParameter = [];
  late List<String> secondaryObserved = [];
  late String alarmName = "";
  late String alarmColor;
  late String alarmColor2;
  late String xvalue = "";
  late String pressure = "";
  late String volume = "";
  late String flow = "";
  
  late List<String> graphData = [];

  late List<String> graphPressure = [];

  late List<String> graphVolume = [];

  late List<String> graphFlow = [];

  @override
  void initState() {
    super.initState();

    chartData = [];
    chartDataVolume = [];
    chartDataFlow = [];
    SocketServices socketService = SocketServices();
    socketService.initializeSocket('http://52.64.235.38:8000', widget.deviceId);
    socketService.setOnDataReceivedCallback((
      receivedModeData,
      receivedObservedData,
      receivedSetParameter,
      receivedSecondaryObserved,
      receivedAlarmName,
      receivedAlarmColor,
      receivedAlarmColor2,
    ) {
      setState(() {
        modeData = receivedModeData;
        observedData = receivedObservedData;
        secondaryObserved = receivedSecondaryObserved;
        setParameter = receivedSetParameter;
        alarmName = receivedAlarmName;
        alarmColor = receivedAlarmColor;
        alarmColor2 = receivedAlarmColor2;
        if (alarmColor == '#F4C430') {
          newColor = Colors.amber;
        } else if (alarmColor == '#AC0303') {
          newColor = Colors.red;
        } else if (alarmColor2 == '#000000') {
          newColor = Colors.black;
        }
        // print("CHECK ALARM $alarmColor+ $alarmName");
      });
    });

  socketService.setOnGraphDataReceivedCallback((receivedXvalue,
    receivedPressure, receivedVolume, receivedFlow, receivedGraphData) {
  setState(() {
    xvalue = receivedXvalue.toString();
    pressure = receivedPressure.toString();
    volume = receivedVolume.toString();
    flow = receivedFlow.toString();
    graphData = receivedGraphData;
    graphPressure.add(xvalue);
    graphPressure.add(pressure);

    graphVolume.add(xvalue);
    graphVolume.add(volume);

    double x = double.parse(xvalue);
    double y = double.parse(pressure);

    // double yvolume = double.parse(volume);

    // double yFlow = double.parse(flow);

    // Update chartData and lineColors
    if (!isFirstTime) {
      if (chartData.length >= 350) {
        // Remove the oldest data point
        chartData.removeAt(0);
        // Adjust lineColors accordingly
        lineColors.removeAt(0);
      }
      chartData.add(FlSpot(x, y));
      lineColors.add(Colors.white); // or any other default color
    } else {
      // Update the existing data point
      chartData[xVal] = FlSpot(x, y);
      // Update lineColors if needed
    }

    xVal = (xVal + 1) % 350;
    isFirstTime = xVal == 0; // Set isFirstTime to true when xVal reaches 350

    // Update lineColors based on fifoLimit
    for (int i = 0; i < chartData.length; i++) {
      if (fifoLimit.contains(i)) {
        lineColors[i] = Colors.black;
      } else {
        lineColors[i] = Colors.white;
      }
    }
  });
});

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                
                spots: chartData,
                isCurved: false,
                // color: Colors.white,
                gradient: LinearGradient(
                  colors: lineColors,
                ),
                barWidth: 2,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: const FlDotData(show: false),
              ),
            ],
            minY: 0,
            gridData: const FlGridData(show: true),
            titlesData: const FlTitlesData(
                // leftTitles:  SideTitles(showTitles: true),
                // bottomTitles: SideTitles(showTitles: true),
                ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}