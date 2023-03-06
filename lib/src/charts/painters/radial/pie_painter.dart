import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/constants/defaults.dart';
import 'package:flutter_charts/src/charts/data/pie/pie_series.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_chart_painter.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_painter.dart';

class PiePainter implements RadialPainter {
  final PieSeries data;

  PiePainter({
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size, RadialChartPainter chart) {
    var circlePaint = Paint()..style = PaintingStyle.stroke;
    final borderPaint = Paint()..style = PaintingStyle.stroke;
    final innerCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    var total = 0.0;
    var startPoint = 0.0;
    var pointRadians = 0.0;

    for (var slice in data.slices) {
      total += slice.value;
    }

    for (var slice in data.slices) {
      var radius = slice.style?.radius ?? defaultPieSeriesStyle.radius;
      var width = slice.style?.strokeWidth ?? defaultPieSeriesStyle.strokeWidth;

      pointRadians = (slice.value * 2 * pi) / total;

      borderPaint.color =
          slice.style?.strokeColor ?? defaultPieSeriesStyle.strokeColor;
      borderPaint.strokeWidth =
          slice.style?.strokeWidth ?? defaultPieSeriesStyle.strokeWidth;

      circlePaint.strokeWidth = width;
      circlePaint.color = slice.style?.color ?? defaultPieSeriesStyle.color;

      canvas.drawArc(
        Rect.fromCircle(
          center: Offset((size.width / 2), (size.height / 2)),
          radius: radius,
        ),
        startPoint,
        pointRadians,
        false,
        circlePaint,
      );

      final dx = (2 * radius + width) / 2.0 * cos(startPoint);
      final dy = (2 * radius + width) / 2.0 * sin(startPoint);
      final d2 = Offset((size.width / 2), (size.height / 2)) + Offset(dx, dy);

      canvas.drawLine(
        Offset((size.width / 2), (size.height / 2)),
        d2,
        borderPaint,
      );

      if (2 * radius > width) {
        canvas.drawCircle(
          Offset((size.width / 2), (size.height / 2)),
          (2 * radius - width) / 2,
          innerCirclePaint,
        );
      }

      startPoint += pointRadians;
    }
  }
}
