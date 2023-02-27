import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class BarChart extends StatefulWidget {
  final Text? title;
  final double? chartWidth;
  final double? chartHeight;
  final CartesianChartStyle? chartStyle;
  final BarSeries data;

  const BarChart({
    Key? key,
    this.title,
    this.chartWidth,
    this.chartHeight,
    this.chartStyle,
    required this.data,
  }) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
