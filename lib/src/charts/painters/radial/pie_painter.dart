import 'dart:math';

import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:chart_it/src/charts/data/pie/pie_series.dart';
import 'package:chart_it/src/charts/painters/radial/radial_chart_painter.dart';
import 'package:chart_it/src/charts/painters/radial/radial_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/extensions/paint_objects.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vm;

class PiePainter implements RadialPainter {
  // late PieSeriesConfig _config;
  late PieSeries _data;

  late Paint _canvasPaint;
  late Paint _arcPaint;
  late Paint _arcStroke;
  late Paint _donutClipper;
  late Paint _donutFill;

  PiePainter() {
    _canvasPaint = Paint();
    _arcPaint = Paint();
    _arcStroke = Paint()..style = PaintingStyle.stroke;
    _donutClipper = Paint();
    _donutFill = Paint();
  }

  @override
  void paint(
    RadialSeries lerpSeries,
    RadialSeries targetSeries,
    Canvas canvas,
    RadialChartPainter chart,
    RadialConfig config,
  ) {
    // Setup the pie chart data
    _data = lerpSeries as PieSeries;

    // Here: We will save the canvas layer and perform the XOR operations first
    canvas.saveLayer(chart.graphConstraints, _canvasPaint);

    var defaultStyle = defaultPieSeriesStyle;
    var seriesRadius = _data.seriesStyle?.radius ?? defaultStyle.radius;

    var total = _data.slices.fold(0.0, (prev, data) => (prev + data.value));

    var startAngle = (chart.style.initAngle - 90.0);
    var pointDegrees = 0.0;
    for (var i = 0; i < _data.slices.length; i++) {
      final slice = _data.slices[i];
      var sliceRadius = slice.style?.radius ?? seriesRadius;
      // We need to ensure that user hasn't provided a radius value
      // that exceeds our max limit to draw a circle within given constraints
      sliceRadius = min(sliceRadius, chart.maxRadius);
      pointDegrees = (slice.value / total) * 360;

      // Styling for Slices
      var sliceFill = slice.style?.color ?? defaultStyle.color!;
      var sliceStrokeWidth =
          slice.style?.strokeWidth ?? defaultStyle.strokeWidth!;
      var sliceStrokeColor =
          slice.style?.strokeColor ?? defaultStyle.strokeColor!;

      // Draw slice with color fill
      var arcPaint = _arcPaint
        ..color = sliceFill
        ..shader =
            (slice.style?.gradient ?? defaultPieSeriesStyle.gradient)?.toShader(
          Rect.fromCircle(
            center: chart.graphOrigin,
            radius: sliceRadius,
          ),
        );

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
        var strokePaint = _arcStroke
          ..color = sliceStrokeColor
          ..strokeWidth = sliceStrokeWidth
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
          length: sliceRadius + 25,
          sweepAngle: startAngle + (pointDegrees * 0.5),
          text: slice.label!(slice.value / total, slice.value),
          style: slice.labelStyle ?? _data.labelStyle!,
        );
      }

      startAngle += pointDegrees;
    }

    // Draw a clipping Circle or a Fill to convert into donut chart
    if ((_data.donutRadius ?? 0) > 0.0) {
      var donutRadius = min(_data.donutRadius!, chart.maxRadius);
      // We have to draw a circle that will clip the slices to create a donut
      var clipper = _donutClipper..blendMode = BlendMode.clear;
      canvas.drawCircle(chart.graphOrigin, donutRadius, clipper);

      var donutSpace = _donutFill
        ..color = _data.donutSpaceColor ?? Colors.transparent;
      canvas.drawCircle(chart.graphOrigin, donutRadius, donutSpace);

      if (_data.donutLabel != null) {
        _drawDonutLabel(
          canvas: canvas,
          text: _data.donutLabel!(),
          style: _data.donutLabelStyle,
          offset: chart.graphOrigin,
        );
      }
    }
    canvas.restore();
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
    required ChartTextStyle style,
  }) {
    // We will calculate the label offset
    // radius * cos(angle) gives you the x-coordinate
    final dx = length * cos(vm.radians(sweepAngle));
    // radius * sin(angle) gives you the y-coordinate
    final dy = length * sin(vm.radians(sweepAngle));
    final labelOffset = center + Offset(dx, dy);

    final textPainter = ChartTextPainter.fromChartTextStyle(
      chartTextStyle: style,
      text: text,
    );

    textPainter.paint(canvas: canvas, offset: labelOffset);
  }

  void _drawDonutLabel({
    required Canvas canvas,
    required String text,
    required ChartTextStyle? style,
    required Offset offset,
  }) {
    final textPainter = ChartTextPainter.fromChartTextStyle(
      chartTextStyle: style ?? const ChartTextStyle(),
      text: text,
    );
    textPainter.paint(canvas: canvas, offset: offset);
  }
}
