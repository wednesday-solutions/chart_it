import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/constants/defaults.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_group.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_series.dart';
import 'package:flutter_charts/src/charts/data/bars/multi_bar.dart';
import 'package:flutter_charts/src/charts/data/bars/simple_bar.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_chart_painter.dart';
import 'package:flutter_charts/src/charts/painters/cartesian_painter.dart';

class BarPainter implements CartesianPainter {
  final BarSeries data;

  BarPainter({
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size, CartesianChartPainter chart) {
    var dx = chart.graphPolygon.left; // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    data.barData.forEach((group) {
      if (group is SimpleBar) {
        // We have to paint a single bar
        _drawBar(canvas, size, chart, dx, group);
      } else if (group is MultiBar) {
        // TODO: We have a bar group to draw.
        if (group.arrangement == BarGroupArrangement.stack) {
          // TODO: Paint Stacked Bars
        } else {
          // TODO: Paint Bar Series across unit width
        }
      }

      dx += chart.unitWidth;
    });

    // We will draw axis on top of the painted bars.
    // There is no 'Z-Index' property as such in canvas. the canvas objects
    // gets stacked on top of each other in the order they were drawn
    chart.drawAxis(canvas, size);
  }

  _drawBar(
    Canvas canvas,
    Size size,
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

    var padding = 5.0;
    // We need to compute the RATIO between the chart height (in pixels) and
    // the range of data! This will come in handy later when we have to
    // compute the vertical pixel value for each data point
    var vRatio = chart.graphHeight / chart.observer.yRange;
    // The first thing to do is to get the data point into the range!
    // This is because we don't want our bar to exceed the min/max values
    // we then multiply it by the vRatio to get the vertical pixel value!
    var y = group.yValue.yValue * vRatio;
    // The x values start from the left side of the chart and then increase by unit width!
    // Note: y values increase from the top to the bottom of the screen, so
    // we have to subtract the computed y value from the chart's bottom to invert the drawing!
    var p1 = Offset(dxOffset + padding, chart.graphPolygon.bottom);
    var p2 = Offset(
      dxOffset + chart.unitWidth - padding,
      chart.graphPolygon.bottom - y,
    );
    var rect = Rect.fromPoints(p1, p2);
    var bar = RRect.fromRectAndCorners(
      rect,
      topLeft: style.cornerRadius?.topLeft ?? Radius.zero,
      topRight: style.cornerRadius?.topRight ?? Radius.zero,
      bottomLeft: style.cornerRadius?.bottomLeft ?? Radius.zero,
      bottomRight: style.cornerRadius?.bottomRight ?? Radius.zero,
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
