import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/interactions/data/touch_interactions.dart';
import 'package:flutter/material.dart';

abstract class CartesianPainter<T extends TouchInteractionResult> {
  T? hitTest(TouchInteractionType type, Offset localPosition);

  void paint(
      {required CartesianSeries lerpSeries,
      required Canvas canvas,
      required CartesianPaintingGeometryData chart,
      required CartesianConfig config,
      required CartesianChartStylingData style});
}
