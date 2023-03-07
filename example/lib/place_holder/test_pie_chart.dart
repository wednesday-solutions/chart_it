import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class TestPieChart extends StatefulWidget {
  const TestPieChart({Key? key}) : super(key: key);

  @override
  State<TestPieChart> createState() => _TestPieChartState();
}

class _TestPieChartState extends State<TestPieChart> {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      title: const Text('Demo Chart'),
      chartWidth: 500,
      chartHeight: 500,
      chartStyle: const RadialChartStyle(
        backgroundColor: Colors.blueGrey,
      ),
      data: PieSeries(
        seriesStyle:
            const SliceDataStyle(radius: 150, color: Colors.cyanAccent),
        slices: <SliceData>[
          const SliceData(
            value: 5,
            style: SliceDataStyle(radius: 150, color: Colors.deepOrange),
          ),
          const SliceData(
            value: 25,
            style: SliceDataStyle(radius: 150, color: Colors.lightGreenAccent),
          ),
          const SliceData(
            value: 30,
            style: SliceDataStyle(radius: 150, color: Colors.cyan),
          ),
        ],
      ),
    );
  }
}
