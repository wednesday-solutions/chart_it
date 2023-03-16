import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:flutter/material.dart';

abstract class CartesianPainter {
  void paint(CartesianSeries data, Canvas canvas, CartesianChartPainter chart);
}
