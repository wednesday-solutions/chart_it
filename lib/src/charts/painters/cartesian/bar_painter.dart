import 'dart:developer';

import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/bars/simple_bar.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/extensions/paint_objects.dart';
import 'package:flutter/material.dart';

class BarPainter implements CartesianPainter {
  late BarSeriesConfig _config;
  late BarSeries _data;

  late double _vRatio;
  late double _unitWidth;
  bool useGraphUnits;

  late Paint _barPaint;
  late Paint _barStroke;

  BarPainter({
    required this.useGraphUnits,
  }) {
    _barPaint = Paint();
    _barStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  @override
  void paint(
    CartesianSeries lerpSeries,
    CartesianSeries targetSeries,
    Canvas canvas,
    CartesianChartPainter chart,
    CartesianConfig config,
  ) {
    assert(
      config is BarSeriesConfig,
      "$BarPainter required $BarSeriesConfig but found ${config.runtimeType}",
    );
    Timeline.startSync('Bar Painter');
    // Setup the bar data
    _data = lerpSeries as BarSeries;
    // Setup the bar chart config
    _config = config as BarSeriesConfig;

    _unitWidth = useGraphUnits ? chart.graphUnitWidth : chart.valueUnitWidth;
    // We need to compute the RATIO between the chart height (in pixels) and
    // the range of data! This will come in handy later when we have to
    // compute the vertical pixel value for each data point
    _vRatio = chart.graphHeight / chart.totalYRange;

    var dx = chart.axisOrigin.dx; // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    for (var i = 0; i < _data.barData.length; i++) {
      Timeline.startSync('Iteration');

      Timeline.startSync('New BarGroup');
      final group = _data.barData[i];
      Timeline.finishSync();
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
      Timeline.finishSync();
    }
    Timeline.finishSync();
  }

  _drawSimpleBar(
    Canvas canvas,
    CartesianChartPainter chart,
    double dxOffset,
    SimpleBar group,
  ) {
    Timeline.startSync('Simple Bar');
    // Precedence take like this
    // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
    var style = group.yValue.barStyle ??
        group.groupStyle ??
        _data.seriesStyle ??
        defaultBarSeriesStyle;

    // Since we have only one yValue, we only have to draw one bar
    var barWidth = _unitWidth / _config.maxBarsInGroup;
    _drawBar(
      canvas,
      chart,
      style,
      dxOffset + (_unitWidth * 0.5) - (barWidth * 0.5),
      // dx pos to start the bar from
      barWidth,
      group.yValue.yValue,
    );
    // Finally paint the y-labels for this bar
    _drawBarValues(canvas, chart, group.yValue);
    Timeline.finishSync();
  }

  _drawBarSeries(
    Canvas canvas,
    CartesianChartPainter chart,
    double dxOffset,
    MultiBar group,
  ) {
    Timeline.startSync('Multi Bar');
    var barWidth = _unitWidth / _config.maxBarsInGroup;
    var groupWidth = _unitWidth / group.yValues.length;
    // Draw individual bars in this group
    var x = dxOffset;
    for (var i = 0; i < group.yValues.length; i++) {
      final barData = group.yValues[i];
      // Precedence take like this
      // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
      var style = barData.barStyle ??
          group.groupStyle ??
          _data.seriesStyle ??
          defaultBarSeriesStyle;

      _drawBar(
        canvas,
        chart,
        style,
        x, // dx pos to start the bar in this group
        barWidth,
        barData.yValue,
      );
      // Finally paint the y-labels for this bar
      _drawBarValues(canvas, chart, barData);

      x += groupWidth;
    }
    Timeline.finishSync();
  }

  _drawBar(
    Canvas canvas,
    CartesianChartPainter chart,
    BarDataStyle? style,
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

    var topLeft = style?.cornerRadius?.topLeft ?? Radius.zero;
    var topRight = style?.cornerRadius?.topRight ?? Radius.zero;
    var bottomLeft = style?.cornerRadius?.bottomLeft ?? Radius.zero;
    var bottomRight = style?.cornerRadius?.bottomRight ?? Radius.zero;

    var bar = RRect.fromLTRBAndCorners(
      dxCenter + padding, // start X + padding
      chart.axisOrigin.dy - y, // axisOrigin's dY - yValue
      dxCenter + barWidth - padding, // startX + barWidth
      chart.axisOrigin.dy, // axisOrigin's dY
      // We are swapping top & bottom corners for negative i.e. inverted bar
      topLeft: yValue.isNegative ? bottomLeft : topLeft,
      topRight: yValue.isNegative ? bottomRight : topRight,
      bottomLeft: yValue.isNegative ? topLeft : bottomLeft,
      bottomRight: yValue.isNegative ? topRight : bottomRight,
    );

    var barPaint = _barPaint
      ..color = (style?.barColor ?? defaultBarSeriesStyle.barColor)!
      ..shader = (style?.gradient ?? defaultBarSeriesStyle.gradient)
          ?.toShader(bar.outerRect);

    canvas.drawRRect(bar, barPaint); // draw fill

    final strokeWidth = style?.strokeWidth ?? defaultBarSeriesStyle.strokeWidth;
    if (strokeWidth != null && strokeWidth > 0.0) {
      var barStroke = _barStroke
        ..strokeWidth = strokeWidth
        ..color = (style?.strokeColor ?? defaultBarSeriesStyle.strokeColor)!;
      canvas.drawRRect(bar, barStroke); // draw stroke
    }
  }

  void _drawGroupLabel(
    Canvas canvas,
    CartesianChartPainter chart,
    double dxOffset,
    BarGroup group,
  ) {
    Timeline.startSync('BarGroup Label');
    // We will draw the Label that the user had provided for our bar group
    if (group.label != null) {
      // TODO: rotate the text if it doesn't fit within the unitWidth
      final textPainter = ChartTextPainter.fromChartTextStyle(
        text: group.label!(group.xValue),
        maxWidth: _unitWidth,
        chartTextStyle:
            group.labelStyle ?? _data.labelStyle ?? defaultChartTextStyle,
      );

      textPainter.paint(
        canvas: canvas,
        offset: Offset(
          dxOffset + (_unitWidth * 0.5),
          chart.graphPolygon.bottom + chart.style.axisStyle!.tickLength + 15,
        ),
      );
    }
    Timeline.finishSync();
  }

  void _drawBarValues(
    Canvas canvas,
    CartesianChartPainter chart,
    BarData data,
  ) {
    Timeline.startSync('Bar Label');
    if (data.label != null) {
      final textPainter = ChartTextPainter.fromChartTextStyle(
        text: data.label!(data.yValue),
        chartTextStyle: data.labelStyle ?? defaultChartTextStyle,
      );

      textPainter.paint(
        canvas: canvas,
        offset: Offset(
          chart.graphPolygon.left - chart.style.axisStyle!.tickLength - 15,
          chart.axisOrigin.dy - (data.yValue * _vRatio),
        ),
      );
    }
    Timeline.finishSync();
  }
}
