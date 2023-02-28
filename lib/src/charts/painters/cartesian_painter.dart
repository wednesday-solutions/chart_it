import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_chart_painter.dart';

abstract class CartesianPainter {
  void paint(Canvas canvas, Size size, CartesianChartPainter chart);
}
