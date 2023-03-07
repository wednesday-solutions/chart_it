import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/constants/defaults.dart';
import 'package:flutter_charts/src/charts/data/pie/pie_series.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_chart_painter.dart';
import 'package:flutter_charts/src/charts/painters/radial/radial_painter.dart';
import 'package:flutter_charts/src/extensions/paint_text.dart';
import 'package:vector_math/vector_math.dart' as vm;

class PiePainter implements RadialPainter {
  final PieSeries data;

  PiePainter({
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size, RadialChartPainter chart) {
    var defaultStyle = defaultPieSeriesStyle;
    var seriesRadius = data.seriesStyle?.radius ?? defaultStyle.radius;

    // final innerCirclePaint = Paint()
    //   ..style = PaintingStyle.fill
    //   ..color = Colors.transparent;

    var total = data.slices.fold(0.0, (prev, data) => (prev + data.value));

    var startAngle = (chart.style.initAngle - 90.0);
    var pointDegrees = 0.0;
    for (var slice in data.slices) {
      var sliceRadius = slice.style?.radius ?? seriesRadius;
      // We need to ensure that user hasn't provided a radius value
      // that exceeds our max limit to draw a circle within given constraints
      sliceRadius = min(sliceRadius, chart.maxRadius);
      pointDegrees = (slice.value / total) * 360;

      // Styling for Slices
      var sliceFill = slice.style?.color ?? defaultStyle.color;
      var sliceStrokeWidth =
          slice.style?.strokeWidth ?? defaultStyle.strokeWidth;
      var sliceStrokeColor =
          slice.style?.strokeColor ?? defaultStyle.strokeColor;

      // Draw slice with color fill
      var arcPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = sliceFill;

      _drawArcWithCenter(
        canvas,
        arcPaint,
        center: chart.graphOrigin,
        radius: sliceRadius,
        startAngle: startAngle,
        sweepDegrees: pointDegrees,
      );

      // Paint the stroke if visible width provided
      if (sliceStrokeWidth > 0.0) {
        var strokePaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = sliceStrokeColor
          ..strokeWidth = sliceStrokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        _drawArcWithCenter(
          canvas,
          strokePaint,
          center: chart.graphOrigin,
          radius: sliceRadius,
          startAngle: startAngle,
          sweepDegrees: pointDegrees,
        );
      }

      if (slice.label != null) {
        _drawSliceLabels(
          canvas,
          center: chart.graphOrigin,
          length: sliceRadius + 50,
          sweepAngle: startAngle + (pointDegrees * 0.5),
          text: slice.label!(slice.value / total, slice.value),
        );
      }

      // TODO: Draw a clipping Circle or a Fill to convert into donut chart
      // if (2 * sliceRadius > width) {
      //   canvas.drawCircle(
      //     Offset((size.width / 2), (size.height / 2)),
      //     (2 * sliceRadius - width) / 2,
      //     innerCirclePaint,
      //   );
      // }

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

  void _drawSliceLabels(
    Canvas canvas, {
    required Offset center,
    required double length,
    required double sweepAngle,
    required String text,
    TextStyle? style,
  }) {
    // We will calculate the label offset
    // radius * cos(angle) gives you the x-coordinate
    final dx = length * cos(vm.radians(sweepAngle));
    // radius * sin(angle) gives you the y-coordinate
    final dy = length * sin(vm.radians(sweepAngle));
    final labelOffset = center + Offset(dx, dy);

    canvas.drawText(labelOffset, text: TextSpan(text: text, style: style));
  }
}
