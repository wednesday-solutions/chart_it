import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../painters/radial_painter.dart';
import 'data_class/pie_chart_style.dart';
import 'data_class/pie_series.dart';

class PieChartPainter extends RadialPainter {
  final PieSeries pieSeries;
  final PieChartStyle chartStyle;

  PieChartPainter({required this.pieSeries, required this.chartStyle});

  @override
  void paint(Canvas canvas, Size size) {
    var circlePaint = Paint()..style = PaintingStyle.stroke;
    final borderPaint = Paint()..style = PaintingStyle.stroke;
    final innerCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    var total = 0.0;
    var startPoint = 0.0;
    var pointRadians = 0.0;

    for (var data in pieSeries.pieData) {
      total += data.value;
    }

    for (var data in pieSeries.pieData) {
      var radius = (data.pieStyle?.radius ?? chartStyle.pieSeriesStyle.radius);
      var width = (data.pieStyle?.width ?? chartStyle.pieSeriesStyle.width);

      pointRadians = (data.value * 2 * pi) / total;

      borderPaint.color = (data.pieStyle?.borderColor ??
          (chartStyle.pieSeriesStyle.borderColor ?? Colors.white));
      borderPaint.strokeWidth = (data.pieStyle?.borderWidth ??
          (chartStyle.pieSeriesStyle.borderWidth ?? 0));

      circlePaint.strokeWidth = width;
      circlePaint.color =
          (data.pieStyle?.pieceColor ?? (chartStyle.pieSeriesStyle.pieceColor));

      canvas.drawArc(
          Rect.fromCircle(
              center: Offset((size.width / 2), (size.height / 2)),
              radius: radius),
          startPoint,
          pointRadians,
          false,
          circlePaint);

      final dx = (2 * radius + width) / 2.0 * cos(startPoint);
      final dy = (2 * radius + width) / 2.0 * sin(startPoint);
      final d2 = Offset((size.width / 2), (size.height / 2)) + Offset(dx, dy);

      canvas.drawLine(
          Offset((size.width / 2), (size.height / 2)), d2, borderPaint);

      if (2 * radius > width) {
        canvas.drawCircle(Offset((size.width / 2), (size.height / 2)),
            (2 * radius - width) / 2, innerCirclePaint);
      }

      startPoint += pointRadians;
    }
  }
}
