import 'package:chart_it/src/charts/painters/chart_it_painter.dart';
import 'package:flutter/material.dart';
import 'package:chart_it/src/charts/painters/radial/radial_chart_painter.dart';

abstract class RadialPainter extends ChartItPainter {
  void paint(Canvas canvas, Size size, RadialChartPainter chart);
}
