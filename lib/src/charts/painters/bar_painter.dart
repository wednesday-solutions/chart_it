import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:flutter_charts/src/charts/constants/defaults.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_chart_painter.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_painter.dart';

class BarPainter implements CartesianPainter {
  late double vRatio;
  final BarSeries data;

  BarPainter({
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size, CartesianChartPainter chart) {
    // We need to compute the RATIO between the chart height (in pixels) and
    // the range of data! This will come in handy later when we have to
    // compute the vertical pixel value for each data point
    vRatio = chart.graphHeight / chart.totalYRange;

    var dx = chart.axisOrigin.dx; // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    data.barData.forEach((group) {
      if (group is SimpleBar) {
        // We have to paint a single bar
        _drawSimpleBar(canvas, chart, dx, group);
      } else if (group is MultiBar) {
        // We need to find the arrangement of our bar group
        if (group.arrangement == BarGroupArrangement.stack) {
          // TODO: Paint Stacked Bars
        } else {
          // Paint Bar Series across unit width
          _drawBarSeries(canvas, size, chart, dx, group);
        }
      }

      dx += chart.unitWidth;
    });
  }

  _drawSimpleBar(
    Canvas canvas,
    CartesianChartPainter chart,
    double dxOffset,
    SimpleBar group,
  ) {
    // Precedence take like this
    // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
    var style = group.yValue.barStyle ??
        group.groupStyle ??
        data.seriesStyle ??
        defaultSeriesStyle;

    // Since we have only one yValue, we only have to draw one bar
    _drawBar(
      canvas,
      chart,
      style,
      dxOffset,
      chart.unitWidth,
      group.yValue.yValue,
    );
  }

  _drawBarSeries(
    Canvas canvas,
    Size size,
    CartesianChartPainter chart,
    double dxOffset,
    MultiBar group,
  ) {
    var barWidth = chart.unitWidth / group.yValues.length;
    // Draw individual bars in this group
    var x = dxOffset;
    group.yValues.forEach((barData) {
      // Precedence take like this
      // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
      var style = barData.barStyle ??
          group.groupStyle ??
          data.seriesStyle ??
          defaultSeriesStyle;
      _drawBar(canvas, chart, style, x, barWidth, barData.yValue);

      x += barWidth;
    });
  }

  _drawBar(
    Canvas canvas,
    CartesianChartPainter chart,
    BarDataStyle style,
    double dxPosition,
    double barWidth,
    num yValue,
  ) {
    var padding = 5.0;
    // The first thing to do is to get the data point into the range!
    // This is because we don't want our bar to exceed the min/max values
    // we then multiply it by the vRatio to get the vertical pixel value!
    var y = yValue * vRatio;
    // The x values start from the left side of the chart and then increase by unit width!
    // Note: y values increase from the top to the bottom of the screen, so
    // we have to subtract the computed y value from the chart's bottom to invert the drawing!
    var p1 = Offset(dxPosition + padding, chart.axisOrigin.dy);
    var p2 = Offset(dxPosition + barWidth - padding, chart.axisOrigin.dy - y);
    var rect = Rect.fromPoints(p1, p2);

    var topLeft = style.cornerRadius?.topLeft ?? Radius.zero;
    var topRight = style.cornerRadius?.topRight ?? Radius.zero;
    var bottomLeft = style.cornerRadius?.bottomLeft ?? Radius.zero;
    var bottomRight = style.cornerRadius?.bottomRight ?? Radius.zero;

    var bar = RRect.fromRectAndCorners(
      rect,
      // We are swapping top & bottom corners for negative i.e. inverted bar
      topLeft: yValue.isNegative ? bottomLeft : topLeft,
      topRight: yValue.isNegative ? bottomRight : topRight,
      bottomLeft: yValue.isNegative ? topLeft : bottomLeft,
      bottomRight: yValue.isNegative ? topRight : bottomRight,
    );

    var barPaint = Paint()
      ..color = (style.barColor ?? defaultSeriesStyle.barColor)!
      ..shader =
          (style.gradient ?? defaultSeriesStyle.gradient) as ui.Gradient?;

    var barStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = (style.strokeWidth ?? defaultSeriesStyle.strokeWidth)!
      ..color = (style.strokeColor ?? defaultSeriesStyle.strokeColor)!;

    canvas.drawRRect(bar, barPaint); // draw fill
    canvas.drawRRect(bar, barStroke); // draw stroke
  }
}
