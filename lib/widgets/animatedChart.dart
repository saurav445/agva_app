// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyLineChart extends StatefulWidget {
  const MyLineChart({Key? key}) : super(key: key);

  final Color sinColor = Colors.white;
  final Color cosColor = Colors.white;

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  final limitCount = 100;
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];

  double X = 0;
  double step = .05;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
        cosPoints.removeAt(0);
      }
      setState(() {
        sinPoints.add(FlSpot(X, .5 * math.sin(20 * X) + .5 * math.sin(5 * X)));
        cosPoints.add(FlSpot(X, math.cos(X)));
      });
      X += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return cosPoints.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 1),
              // Text(
              //   'X:${X.toStringAsFixed(1)}',
              //   style: const TextStyle(
              //     color: Colors.grey,
              //     fontSize: 10,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),

              // Text(
              //   '.5Sin(20X) + .5sin(5*x):${sinPoints.last.y.toStringAsFixed(1)}',
              //   style: const TextStyle(
              //     color: Colors.grey,
              //     fontSize: 10,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),

              // Text(
              //   'cos(X):${cosPoints.last.y.toStringAsFixed(1)}',
              //   style: const TextStyle(
              //     color: Colors.grey,
              //     fontSize: 10,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(height: 5),

              AspectRatio(
                aspectRatio: 2.5,
                child: LineChart(LineChartData(
                  minY: -1,
                  maxY: 1,
                  minX: sinPoints.first.x,
                  maxX: sinPoints.last.x,
                  lineTouchData: LineTouchData(enabled: false),
                  clipData: FlClipData.all(),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    sinLine(sinPoints),
                    // cosLine(cosPoints),
                  ],
                  titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
                )),
              )
            ],
          )
        : Container();
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      gradient: LinearGradient(
        colors: [widget.sinColor.withOpacity(0), widget.sinColor],
        stops: [.1, 1],
      ),
      belowBarData:BarAreaData(show: true, color: Colors.orangeAccent[100]),
      barWidth: 0,
      isCurved: false,
    );
  }

  LineChartBarData cosLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(show: false),
      gradient: LinearGradient(
        colors: [widget.cosColor.withOpacity(0), widget.cosColor],
        stops: const [.1, 1],
      ),
      barWidth: 5,
      isCurved: false,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
