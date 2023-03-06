import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_chart_painter.dart';

abstract class RadialPainter {
  void paint(Canvas canvas, Size size, RadialChartPainter chart);
}
