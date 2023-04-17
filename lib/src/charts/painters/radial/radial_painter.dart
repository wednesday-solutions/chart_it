import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/painters/radial/radial_chart_painter.dart';
import 'package:flutter/material.dart';

abstract class RadialPainter {
  void paint(
    RadialSeries lerp,
    Canvas canvas,
    RadialChartPainter chart,
    RadialConfig config,
  );
}
