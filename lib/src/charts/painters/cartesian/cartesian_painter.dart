import 'package:flutter/material.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';

abstract class CartesianPainter<T> {
  void paint(Canvas canvas, Size size, CartesianChartPainter chart);
}
