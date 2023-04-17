import 'dart:math';

import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/pie.dart';
import 'package:chart_it/src/charts/painters/radial/radial_chart_painter.dart';
import 'package:chart_it/src/charts/painters/radial/radial_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/extensions/paint_objects.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vm;

class PiePainter implements RadialPainter {
  // late PieSeriesConfig _config;
  late PieSeries _data;

  late Paint _arcPaint;
  late Paint _arcStroke;
  late Paint _donutFill;

  PiePainter() {
    _arcPaint = Paint();
    _arcStroke = Paint()..style = PaintingStyle.stroke;
    _donutFill = Paint();
  }

  @override
  void paint(
    RadialSeries lerpSeries,
    Canvas canvas,
    RadialChartPainter chart,
    RadialConfig config,
  ) {
    // Setup the pie chart data
    _data = lerpSeries as PieSeries;

    var defaultStyle = defaultPieSeriesStyle;
    var seriesRadius = _data.seriesStyle?.radius ?? defaultStyle.radius;

    var total = _data.slices.fold(0.0, (prev, data) => (prev + data.value));

    var fillStartAngle = (chart.style.initAngle - 90.0);
    var strokeStartAngle = (chart.style.initAngle - 90.0);

    var fillPointDegrees = 0.0;
    var strokePointDegrees = 0.0;

    for (var i = 0; i < _data.slices.length; i++) {
      final slice = _data.slices[i];
      var sliceRadius = slice.style?.radius ?? seriesRadius;
      // We need to ensure that user hasn't provided a radius value
      // that exceeds our max limit to draw a circle within given constraints
      sliceRadius = min(sliceRadius, chart.maxRadius);
      fillPointDegrees = (slice.value / total) * 360;

      if (slice.value > 0) {
        // Styling for Slices
        var sliceFill = slice.style?.color ??
            _data.seriesStyle?.color ??
            defaultStyle.color!;

        // Draw slice with color fill
        var arcPaint = _arcPaint
          ..color = sliceFill
          ..shader = (slice.style?.gradient ?? defaultPieSeriesStyle.gradient)
              ?.toShader(
            Rect.fromCircle(
              center: chart.graphOrigin,
              radius: sliceRadius,
            ),
          );

        _drawArcGroup(
          canvas,
          arcPaint,
          _donutFill..color = _data.donutSpaceColor ?? Colors.transparent,
          center: chart.graphOrigin,
          radius: sliceRadius,
          startAngle: fillStartAngle,
          sweepDegrees: fillPointDegrees,
          donutRadius: min(_data.donutRadius, chart.maxRadius),
          isDonut: _data.donutRadius > 0.0,
        );

        if (slice.label != null) {
          var labelPos = slice.style?.labelPosition ??
              _data.seriesStyle?.labelPosition ??
              (sliceRadius + 30);
          _drawSliceLabels(
            canvas,
            center: chart.graphOrigin,
            length: labelPos,
            sweepAngle: fillStartAngle + (fillPointDegrees * 0.5),
            text: slice.label!(slice.value / total, slice.value),
            style: slice.labelStyle ?? _data.labelStyle!,
          );
        }
      }

      fillStartAngle += fillPointDegrees;
    }

    for (var i = 0; i < _data.slices.length; i++) {
      final slice = _data.slices[i];
      var sliceRadius = slice.style?.radius ?? seriesRadius;
      // We need to ensure that user hasn't provided a radius value
      // that exceeds our max limit to draw a circle within given constraints
      sliceRadius = min(sliceRadius, chart.maxRadius);
      strokePointDegrees = (slice.value / total) * 360;

      if (slice.value > 0) {
        var sliceStrokeWidth = slice.style?.strokeWidth ??
            _data.seriesStyle?.strokeWidth ??
            defaultStyle.strokeWidth!;
        var sliceStrokeColor = slice.style?.strokeColor ??
            _data.seriesStyle?.strokeColor ??
            defaultStyle.strokeColor!;

        // Paint the stroke if visible width provided
        if (sliceStrokeWidth > 0.0) {
          var strokePaint = _arcStroke
            ..color = sliceStrokeColor
            ..strokeWidth = sliceStrokeWidth
            ..strokeJoin = StrokeJoin.round;

          _drawArcBorder(
            canvas,
            strokePaint,
            center: chart.graphOrigin,
            radius: sliceRadius,
            startAngle: strokeStartAngle,
            sweepDegrees: strokePointDegrees,
            donutRadius: min(_data.donutRadius, chart.maxRadius),
            isDonut: _data.donutRadius > 0.0,
          );
        }
      }

      strokeStartAngle += strokePointDegrees;
    }

    // Draw a label in the Circle donut chart
    if (_data.donutLabel != null) {
      _drawDonutLabel(
        canvas: canvas,
        text: _data.donutLabel!(),
        style: _data.donutLabelStyle,
        offset: chart.graphOrigin,
      );
    }
  }

  _drawArcGroup(
    Canvas canvas,
    Paint slicePaint,
    Paint? donutPaint, {
    required Offset center,
    required double radius,
    startAngle = 0.0,
    sweepDegrees = 360,
    donutRadius = 0.0,
    isDonut = false,
  }) {
    // Step 1. Draw our Pie Slice
    var slicePath = Path();
    slicePath.moveTo(center.dx, center.dy);
    slicePath.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      vm.radians(startAngle),
      vm.radians(sweepDegrees),
      false,
    );
    slicePath.close();

    if (isDonut && donutRadius > 0.0) {
      // Step 2. Chop the Donut Slice from Pie Piece
      var clippingPath = Path();
      clippingPath.moveTo(center.dx, center.dy);
      clippingPath.arcTo(
        Rect.fromCircle(center: center, radius: donutRadius),
        vm.radians(startAngle),
        vm.radians(sweepDegrees),
        false,
      );
      clippingPath.close();

      canvas.drawPath(
        Path.combine(PathOperation.difference, slicePath, clippingPath),
        slicePaint,
      );

      // Provide fill to the donut piece if available
      if (donutPaint != null) {
        var donutFillPath = Path();
        donutFillPath.moveTo(center.dx, center.dy);
        donutFillPath.arcTo(
          Rect.fromCircle(center: center, radius: donutRadius),
          vm.radians(startAngle),
          vm.radians(sweepDegrees),
          false,
        );
        donutFillPath.close();

        canvas.drawPath(donutFillPath, donutPaint);
      }
    } else {
      canvas.drawPath(slicePath, slicePaint);
    }
  }

  _drawArcBorder(
    Canvas canvas,
    Paint sliceBorder, {
    required Offset center,
    required double radius,
    startAngle = 0.0,
    sweepDegrees = 360,
    donutRadius = 0.0,
    isDonut = false,
  }) {
    // Step 1. Draw our Pie Slice
    var slicePath = Path();
    slicePath.moveTo(center.dx, center.dy);
    slicePath.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      vm.radians(startAngle),
      vm.radians(sweepDegrees),
      false,
    );
    slicePath.close();

    if (isDonut && donutRadius > 0.0) {
      // Step 2. Chop the Donut Slice from Pie Piece
      var clippingPath = Path();
      clippingPath.moveTo(center.dx, center.dy);
      clippingPath.arcTo(
        Rect.fromCircle(center: center, radius: donutRadius),
        vm.radians(startAngle),
        vm.radians(sweepDegrees),
        false,
      );
      clippingPath.close();

      canvas.drawPath(
        Path.combine(PathOperation.xor, slicePath, clippingPath),
        sliceBorder,
      );
    } else {
      canvas.drawPath(slicePath, sliceBorder);
    }
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
      chartTextStyle: style ?? defaultChartTextStyle,
      text: text,
    );
    textPainter.paint(canvas: canvas, offset: offset);
  }
}
