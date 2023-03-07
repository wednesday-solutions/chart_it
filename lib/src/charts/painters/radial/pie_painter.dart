import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/constants/defaults.dart';
import 'package:flutter_charts/src/charts/data/pie/pie_series.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_chart_painter.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_painter.dart';
import 'package:vector_math/vector_math.dart' as vm;

class PiePainter implements RadialPainter {
  final PieSeries data;

  PiePainter({
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size, RadialChartPainter chart) {
    var seriesRadius = data.seriesStyle?.radius ?? defaultPieSeriesStyle.radius;
    var arcPaint = Paint()..style = PaintingStyle.fill;

    final innerCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.transparent;

    var total = 0.0;
    for (var slice in data.slices) {
      total += slice.value;
    }

    var startAngle = -90.0;
    var pointDegrees = 0.0;
    for (var slice in data.slices) {
      var sliceRadius = slice.style?.radius ?? seriesRadius;
      // We need to ensure that user hasn't provided a radius value
      // that exceeds our max limit to draw a circle within given constraints
      sliceRadius = min(sliceRadius, chart.maxRadius);
      pointDegrees = (slice.value / total) * 360;

      var width = slice.style?.strokeWidth ?? defaultPieSeriesStyle.strokeWidth;

      arcPaint.strokeWidth =
          slice.style?.strokeWidth ?? defaultPieSeriesStyle.strokeWidth;
      arcPaint.color = slice.style?.color ?? defaultPieSeriesStyle.color;

      _drawArcWithCenter(
        canvas,
        arcPaint,
        center: Offset((size.width / 2), (size.height / 2)),
        radius: sliceRadius,
        startAngle: startAngle,
        sweepDegrees: pointDegrees,
      );

      if (2 * sliceRadius > width) {
        canvas.drawCircle(
          Offset((size.width / 2), (size.height / 2)),
          (2 * sliceRadius - width) / 2,
          innerCirclePaint,
        );
      }

      startAngle += pointDegrees;
    }
  }

  void _drawArcWithCenter(
    Canvas canvas,
    Paint paint, {
    required Offset center,
    required double radius,
    startAngle = 0.0,
    sweepDegrees = 360,
  }) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      vm.radians(startAngle),
      vm.radians(sweepDegrees),
      true,
      paint,
    );
  }
}
