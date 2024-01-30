// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  bool showAvg = false;
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    spots = generateRandomData();

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        spots = updateChartData();
      });
    });
  }

  List<FlSpot> generateRandomData() {
    return List.generate(7, (index) {
      return FlSpot(index.toDouble(), Random().nextDouble() * 8);
    });
  }

  List<FlSpot> updateChartData() {
    spots.removeAt(0);
    spots.add(FlSpot(spots.length.toDouble(), Random().nextDouble() * 8));
    return List.from(spots);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 6,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 2,
              left: 2,
              top: 2,
              bottom: 2,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
        Container(
          width: 40,
          height: MediaQuery.of(context).size.height * 0.2,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '30',
                  style: TextStyle(
                    fontSize: 8,
                    color:
                        showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                  ),
                ),
                Text(
                  '0',
                  style: TextStyle(
                    fontSize: 8,
                    color:
                        showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget bottomTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 2,
  //   );
  //   Widget text;
  //   switch (value.toInt()) {
  //     case 2:
  //       text = const Text('MAR', style: style);
  //       break;
  //     case 5:
  //       text = const Text('JUN', style: style);
  //       break;
  //     case 8:
  //       text = const Text('SEP', style: style);
  //       break;
  //     default:
  //       text = const Text('', style: style);
  //       break;
  //   }

  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     child: text,
  //   );
  // }

  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 3,
  //   );
  //   String text;
  //   switch (value.toInt()) {
  //     case 1:
  //       text = '10K';
  //       break;
  //     case 3:
  //       text = '30k';
  //       break;
  //     case 5:
  //       text = '50k';
  //       break;
  //     default:
  //       return Container();
  //   }

  //   return Text(text, style: style, textAlign: TextAlign.left);
  // }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        // getDrawingHorizontalLine: (value) {
        //   return const FlLine(
        //     color: Colors.black,
        //     strokeWidth: 1,
        //   );
        // },
        // getDrawingVerticalLine: (value) {
        //   return const FlLine(
        //          color: Colors.black,
        //     strokeWidth: 1,
        //   );
        // },
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            interval: 1,
            // getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize: 20,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 8.7,
      minY: 0,
      maxY: 8,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 5),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: false,
          barWidth: 1,
          color: Colors.white,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:math';

// class LineChartSample2 extends StatefulWidget {
//   const LineChartSample2({Key? key}) : super(key: key);

//   @override
//   State<LineChartSample2> createState() => _LineChartSample2State();
// }

// class _LineChartSample2State extends State<LineChartSample2> {
//   bool showAvg = false;
//   List<FlSpot> spots = [];
//   late StreamController<List<FlSpot>> _streamController;

//   @override
//   void initState() {
//     super.initState();
//     spots = generateRandomData();
//     _streamController = StreamController<List<FlSpot>>();
//     _startUpdatingChartData();
//   }

//   void _startUpdatingChartData() {
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         spots = updateChartData();
//         _streamController.add(spots); // Emit the updated spots
//       });
//     });
//   }

//   List<FlSpot> generateRandomData() {
//     return List.generate(7, (index) {
//       return FlSpot(index.toDouble(), Random().nextDouble() * 8);
//     });
//   }

//   List<FlSpot> updateChartData() {
//     spots.removeAt(2);
//     spots.add(FlSpot(spots.length.toDouble(), Random().nextDouble() * 8));
//     return List.from(spots);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Container(
//             height: MediaQuery.of(context).size.height * 0.5,
//             width: MediaQuery.of(context).size.width * 0.73,
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 right: 2,
//                 left: 2,
//                 top: 2,
//                 bottom: 2,
//               ),
//               child: LineChart(
//                 mainData(),
//               ),
//             ),
//           ),
//           Container(
//             width: 40,
//             height: MediaQuery.of(context).size.height * 0.2,
//             child: TextButton(
//               onPressed: () {
//                 setState(() {
//                   showAvg = !showAvg;
//                 });
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '30',
//                     style: TextStyle(
//                       fontSize: 8,
//                       color: showAvg
//                           ? Colors.white.withOpacity(0.5)
//                           : Colors.white,
//                     ),
//                   ),
//                   Text(
//                     '0',
//                     style: TextStyle(
//                       fontSize: 8,
//                       color: showAvg
//                           ? Colors.white.withOpacity(0.5)
//                           : Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   LineChartData mainData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: false,
//         drawVerticalLine: false,
//         horizontalInterval: 1,
//         verticalInterval: 1,
//       ),
//       titlesData: FlTitlesData(
//         show: false,
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//             reservedSize: 30,
//             interval: 1,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//             interval: 1,
//             reservedSize: 20,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: false,
//         border: Border.all(color: const Color(0xff37434d)),
//       ),
//       minX: 0,
//       maxX: spots.length.toDouble() - 1,
//       minY: 0,
//       maxY: 8,
//       lineBarsData: [
//         LineChartBarData(
//           spots: spots,
//           isCurved: true,
//           barWidth: 1,
//           color: Colors.white,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//           ),
//         ),
//       ],
//     );
//   }
// }
