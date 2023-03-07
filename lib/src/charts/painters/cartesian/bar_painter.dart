import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:flutter_charts/src/charts/constants/defaults.dart';
import 'package:flutter_charts/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:flutter_charts/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:flutter_charts/src/extensions/paint_text.dart';

class BarPainter implements CartesianPainter {
  late double _vRatio;
  late double _unitWidth;
  final BarSeries data;
  final bool useGraphUnits;
  final int maxBarsInGroup;

  BarPainter({
    required this.data,
    required this.useGraphUnits,
    this.maxBarsInGroup = 1,
  });

  @override
  void paint(Canvas canvas, Size size, CartesianChartPainter chart) {
    _unitWidth = useGraphUnits ? chart.graphUnitWidth : chart.valueUnitWidth;
    // We need to compute the RATIO between the chart height (in pixels) and
    // the range of data! This will come in handy later when we have to
    // compute the vertical pixel value for each data point
    _vRatio = chart.graphHeight / chart.totalYRange;

    var dx = chart.axisOrigin.dx; // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    for (final group in data.barData) {
      if (group is SimpleBar) {
        // We have to paint a single bar
        _drawSimpleBar(canvas, chart, dx, group);
      } else if (group is MultiBar) {
        // We need to find the arrangement of our bar group
        if (group.arrangement == BarGroupArrangement.stack) {
          // TODO: Paint Stacked Bars
        } else {
          // Paint Bar Series across unit width
          _drawBarSeries(canvas, chart, dx, group);
        }
      }

      _drawGroupLabel(canvas, chart, dx, group);

      dx += _unitWidth;
    }
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
        defaultBarSeriesStyle;

    // Since we have only one yValue, we only have to draw one bar
    var barWidth = _unitWidth / maxBarsInGroup;
    _drawBar(
      canvas,
      chart,
      style,
      dxOffset + (_unitWidth * 0.5), // dx pos for center of the unit
      barWidth,
      group.yValue.yValue,
    );
    // Finally paint the y-labels for this bar
    _drawBarValues(canvas, chart, group.yValue);
  }

  _drawBarSeries(
    Canvas canvas,
    CartesianChartPainter chart,
    double dxOffset,
    MultiBar group,
  ) {
    var barWidth = _unitWidth / maxBarsInGroup;
    var groupWidth = _unitWidth / group.yValues.length;
    // Draw individual bars in this group
    var x = dxOffset;
    for (final barData in group.yValues) {
      // Precedence take like this
      // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
      var style = barData.barStyle ??
          group.groupStyle ??
          data.seriesStyle ??
          defaultBarSeriesStyle;

      _drawBar(
        canvas,
        chart,
        style,
        x + (groupWidth * 0.5), // dx pos for center of each group
        barWidth,
        barData.yValue,
      );
      // Finally paint the y-labels for this bar
      _drawBarValues(canvas, chart, barData);

      x += groupWidth;
    }
  }

  _drawBar(
    Canvas canvas,
    CartesianChartPainter chart,
    BarDataStyle style,
    double dxCenter,
    double barWidth,
    num yValue,
  ) {
    var padding = 5.0;
    // The first thing to do is to get the data point into the range!
    // This is because we don't want our bar to exceed the min/max values
    // we then multiply it by the vRatio to get the vertical pixel value!
    var y = yValue * _vRatio;
    // The x values start from the left side of the chart and then increase by unit width!
    // Note: y values increase from the top to the bottom of the screen, so
    // we have to subtract the computed y value from the chart's bottom to invert the drawing!
    var rect = Rect.fromCenter(
      center: Offset(dxCenter, chart.axisOrigin.dy - (y * 0.5)),
      // center of bar
      width: barWidth - (2 * padding),
      height: y,
    );

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
      ..color = (style.barColor ?? defaultBarSeriesStyle.barColor)!
      ..shader =
          (style.gradient ?? defaultBarSeriesStyle.gradient) as ui.Gradient?;

    var barStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = (style.strokeWidth ?? defaultBarSeriesStyle.strokeWidth)!
      ..color = (style.strokeColor ?? defaultBarSeriesStyle.strokeColor)!;

    canvas.drawRRect(bar, barPaint); // draw fill
    canvas.drawRRect(bar, barStroke); // draw stroke
  }

  void _drawGroupLabel(
    Canvas canvas,
    CartesianChartPainter chart,
    double dxOffset,
    BarGroup group,
  ) {
    // We will draw the Label that the user had provided for our bar group
    if (group.label != null) {
      // TODO: rotate the text if it doesn't fit within the unitWidth
      canvas.drawText(
        Offset(
          dxOffset + (_unitWidth * 0.5),
          chart.graphPolygon.bottom + chart.style.axisStyle!.tickLength + 15,
        ),
        text: TextSpan(text: group.label!(group.xValue)),
      );
    }
  }

  void _drawBarValues(
    Canvas canvas,
    CartesianChartPainter chart,
    BarData data,
  ) {
    if (data.label != null) {
      canvas.drawText(
        Offset(
          chart.graphPolygon.left - chart.style.axisStyle!.tickLength - 15,
          chart.axisOrigin.dy - (data.yValue * _vRatio),
        ),
        text: TextSpan(text: data.label!(data.yValue)),
        align: TextAlign.end,
      );
    }
  }
}
