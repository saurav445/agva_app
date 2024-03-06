// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class LineChartWidget extends StatefulWidget {
//   final String xvalue, pressure, volume, flow;

//   LineChartWidget(this.xvalue, this.pressure, this.volume, this.flow);

//   @override
//   _LineChartWidgetState createState() => _LineChartWidgetState();
// }

// class _LineChartWidgetState extends State<LineChartWidget> {
//   late StreamController<List<FlSpot>> streamController;

//   @override
//   void initState() {
//     super.initState();

//     streamController = StreamController<List<FlSpot>>();

//     Timer.periodic(Duration(milliseconds: 1000), (timer) {
//       List<FlSpot> data = [
//         // FlSpot(double.parse(widget.xvalue), double.parse(widget.pressure)),
//       ];

//       streamController.add(data);
//     });
//   }

//   @override
//   void dispose() {
//     streamController.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: StreamBuilder<List<FlSpot>>(
//         stream: streamController.stream,
//         builder: (context, snapshot) {
//           return LineChart(
//             LineChartData(
//               gridData: FlGridData(show: false),
//               titlesData: FlTitlesData(show: false),
//               borderData: FlBorderData(
//                 show: false,
//                 border: Border.all(color: const Color(0xff37434d), width: 1),
//               ),
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: snapshot.data!,
//                   isCurved: false,
//                   // barWidth: 1,
//                   color: Colors.white,
//                   dotData: FlDotData(show: false),
//                   belowBarData: BarAreaData(show: true),
//                 ),
//               ],
//               minX: 0,
//               maxX: 1,
//               // minX: 0,
//               // maxX: 0,
//               minY: 0,
//               maxY: 50,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Linedata extends StatefulWidget {
  //   final String xvalue, pressure, volume, flow;
  // Linedata(this.xvalue, this.pressure, this.volume, this.flow);

  final Color sinColor = Colors.white;

  @override
  State<Linedata> createState() => _LinedataState();
}

class _LinedataState extends State<Linedata> {
  // late String xvalue;
  
  final limitCount = 100;
  final sinPoints = <FlSpot>[];

  double X = 0;
  double step = .5;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    // print(xvalue);

    for (double x = -100; x <= 0; x += step) {
      sinPoints.add(FlSpot(x, .5 * math.sin(20 * x) + .5 * math.sin(5 * x)));
    }

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
      }
      setState(() {
        sinPoints.add(FlSpot(X, .5 * math.sin(20 * X) + .5 * math.sin(5 * X)));
      });
      X += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 7.1,
          child: LineChart(
            LineChartData(
              minY: -1,
              maxY: 1,
              minX: sinPoints.last.x,
              maxX: sinPoints.first.x,
              lineTouchData: LineTouchData(enabled: false),
              clipData: FlClipData.all(),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                sinLine(sinPoints),
              ],
              titlesData: FlTitlesData(
  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        )
      ],
    );
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      gradient: LinearGradient(
        colors: [widget.sinColor.withOpacity(0), widget.sinColor],
        stops: const [.1, 1],
      ),
      belowBarData: BarAreaData(show: true, color: const Color.fromARGB(255, 255, 255, 255)),
      barWidth: 1,
      isCurved: false,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}



// import 'dart:async';
// import 'dart:math' as math;
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class MyLineChart extends StatefulWidget {
//   const MyLineChart({Key? key}) : super(key: key);

//   final Color sinColor = Colors.white;

//   @override
//   State<MyLineChart> createState() => _MyLineChartState();
// }

// class _MyLineChartState extends State<MyLineChart> {
//   final limitCount = 100;
//   final sinPoints = <FlSpot>[];

//   double X = 0;
//   double step = .05;

//   late Timer timer;

//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       while (sinPoints.length > limitCount) {
//         sinPoints.removeAt(0);
//       }
//       setState(() {
//         sinPoints.add(FlSpot(X, .5 * math.sin(20 * X) + .5 * math.sin(5 * X)));
//       });
//       X += step;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(height: 1),
//         // Text(
//         //   'X:${X.toStringAsFixed(1)}',
//         //   style: const TextStyle(
//         //     color: Colors.grey,
//         //     fontSize: 10,
//         //     fontWeight: FontWeight.bold,
//         //   ),
//         // ),

//         // Text(
//         //   '.5Sin(20X) + .5sin(5*x):${sinPoints.last.y.toStringAsFixed(1)}',
//         //   style: const TextStyle(
//         //     color: Colors.grey,
//         //     fontSize: 10,
//         //     fontWeight: FontWeight.bold,
//         //   ),
//         // ),

//         // Text(
//         //   'cos(X):${cosPoints.last.y.toStringAsFixed(1)}',
//         //   style: const TextStyle(
//         //     color: Colors.grey,
//         //     fontSize: 10,
//         //     fontWeight: FontWeight.bold,
//         //   ),
//         // ),
//         // SizedBox(height: 5),

//         AspectRatio(
//           aspectRatio: 2.5,
//           child: LineChart(LineChartData(
//             minY: -1,
//             maxY: 1,
//             minX: sinPoints.last.x,
//             maxX: sinPoints.first.x,
//             lineTouchData: LineTouchData(enabled: false),
//             clipData: FlClipData.all(),
//             gridData: FlGridData(show: true),
//             borderData: FlBorderData(show: false),
//             lineBarsData: [
//               sinLine(sinPoints),
//               // cosLine(cosPoints),
//             ],
//             titlesData: FlTitlesData(
//               leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
//               rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
//               bottomTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//             ),
//           )),
//         )
//       ],
//     );
//   }

//   LineChartBarData sinLine(List<FlSpot> points) {
//     return LineChartBarData(
//       spots: points,
//       dotData: FlDotData(show: false),
//       gradient: LinearGradient(
//         colors: [widget.sinColor.withOpacity(0), widget.sinColor],
//         stops: [.1, 1],
//       ),
//       belowBarData: BarAreaData(show: true, color: Colors.orangeAccent[100]),
//       barWidth: 0,
//       isCurved: false,
//     );
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }
// }
