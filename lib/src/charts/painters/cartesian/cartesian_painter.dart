import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/chart_it_painter.dart';
import 'package:flutter/material.dart';

abstract class CartesianPainter extends ChartItPainter {
  void paint(CartesianSeries data, Canvas canvas, CartesianChartPainter chart);

  static T when<T>({
    required CartesianPainter painter,
    required T Function(BarPainter barPainter) barPainter,
  }) {
    switch (painter.runtimeType) {
      case BarPainter:
        return barPainter(painter as BarPainter);
      default:
        throw TypeError();
    }
  }
}
