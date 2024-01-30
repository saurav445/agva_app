import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget(graphdata, {Key? key}) : super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late List<FlSpot> graphdata;
  late StreamController<List<FlSpot>> streamController;

  @override
  void initState() {
    super.initState();
    graphdata = generateRandomData();

    streamController = StreamController<List<FlSpot>>();
    streamController.add(graphdata);

    Timer.periodic(Duration(seconds: 1), (timer) {
      graphdata = generateRandomData();
      streamController.add(graphdata);
    });
  }

  List<FlSpot> generateRandomData() {
    Random random = Random();
    List<FlSpot> data = [];

    for (int x = 0; x < 7; x++) {
      double randomY = random.nextDouble() * (99 - 10) + 10;
      data.add(FlSpot(x.toDouble(), randomY));
    }

    return data;
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(
            show: false,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: graphdata,
              isCurved: false,
              barWidth: 0.7,
              color: Colors.white,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

