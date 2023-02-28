import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/pie_charts/data_class/pie_chart_style.dart';
import 'package:flutter_charts/src/charts/pie_charts/data_class/pie_series.dart';
import 'package:flutter_charts/src/charts/pie_charts/pie_chart_listener.dart';
import 'package:flutter_charts/src/charts/pie_charts/pie_chart_painter.dart';
import '../painters/radial_chart_painter.dart';

class PieChart extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final PieSeries pieSeries;
  final PieChartStyle chartStyle;

  const PieChart(
      {super.key,
      required this.minValue,
      required this.maxValue,
      required this.pieSeries,
      required this.chartStyle});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadialChartPainter(
          observer: PieChartListener(minValue, maxValue),
          painters: [
            PieChartPainter(pieSeries: pieSeries, chartStyle: chartStyle)
          ]),
    );
  }
}
