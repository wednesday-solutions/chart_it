import 'package:flutter/cupertino.dart';
import 'dataset.dart';

class BarChart extends StatefulWidget {
  final Dataset? dataset;

  const BarChart({super.key, this.dataset});

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return const Text('Hello World');
  }
}
