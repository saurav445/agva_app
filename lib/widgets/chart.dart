import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatefulWidget {
  final String xvalue, pressure, volume, flow;

  LineChartWidget(this.xvalue, this.pressure, this.volume, this.flow);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late StreamController<List<FlSpot>> streamController;

  @override
  void initState() {
    super.initState();

    streamController = StreamController<List<FlSpot>>();

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      List<FlSpot> data = [
        // FlSpot(0, int.parse(widget.xvalue) as double),
        FlSpot(0, double.parse(widget.pressure)),
        FlSpot(1, double.parse(widget.volume)),
        FlSpot(2, double.parse(widget.flow)),
      ];

      streamController.add(data);
    });
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
      child: StreamBuilder<List<FlSpot>>(
          stream: streamController.stream,
          builder: (context, snapshot) {
            return LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                minX: 0,
                maxX: 2,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: snapshot.data!,
                    isCurved: true,
                    color: Colors.white,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: true),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
