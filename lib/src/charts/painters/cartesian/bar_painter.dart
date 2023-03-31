import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/extensions/paint_objects.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/material.dart';

class BarPainter implements CartesianPainter {
  late BarSeriesConfig _config;
  late BarSeries _data;

  late double _vRatio;
  late double _unitWidth;
  final bool useGraphUnits;

  BarPainter({
    required this.useGraphUnits,
  });

  @override
  void paint(
    CartesianSeries lerpSeries,
    CartesianSeries targetSeries,
    Canvas canvas,
    CartesianChartPainter chart,
  ) {
    // Setup the bar data
    _data = lerpSeries as BarSeries;
    // Setup the bar chart config
    var config = chart.controller.getConfig(targetSeries);
    if (config == null) {
      throw ArgumentError('Invalid State! Couldn\'t find a config for $_data');
    } else {
      _config = config.asOrNull<BarSeriesConfig>()!;
    }

    _unitWidth = useGraphUnits ? chart.graphUnitWidth : chart.valueUnitWidth;
    // We need to compute the RATIO between the chart height (in pixels) and
    // the range of data! This will come in handy later when we have to
    // compute the vertical pixel value for each data point
    _vRatio = chart.graphHeight / chart.totalYRange;

    var dx = chart.axisOrigin.dx; // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    for (var i = 0; i < _data.barData.length; i++) {
      final group = _data.barData[i];
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
        _data.seriesStyle ??
        defaultBarSeriesStyle;

    // Since we have only one yValue, we only have to draw one bar
    var barWidth = _unitWidth / _config.maxBarsInGroup;
    _drawBar(
      canvas,
      chart,
      style,
      dxOffset, // dx pos to start the bar from
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
    // var rect = Rect.fromCenter(
    //   center: Offset(dxCenter, chart.axisOrigin.dy - (y * 0.5)),
    //   // center of bar
    //   width: barWidth - (2 * padding),
    //   height: y,
    // );

    var topLeft = style?.cornerRadius?.topLeft ?? Radius.zero;
    var topRight = style?.cornerRadius?.topRight ?? Radius.zero;
    var bottomLeft = style?.cornerRadius?.bottomLeft ?? Radius.zero;
    var bottomRight = style?.cornerRadius?.bottomRight ?? Radius.zero;

    var bar = RRect.fromLTRBAndCorners(
      dxCenter + padding, // start X + padding
      chart.axisOrigin.dy - y, // axisOrigin's dY - yValue
      dxCenter + barWidth, // startX + barWidth
      chart.axisOrigin.dy, // axisOrigin's dY
      // We are swapping top & bottom corners for negative i.e. inverted bar
      topLeft: yValue.isNegative ? bottomLeft : topLeft,
      topRight: yValue.isNegative ? bottomRight : topRight,
      bottomLeft: yValue.isNegative ? topLeft : bottomLeft,
      bottomRight: yValue.isNegative ? topRight : bottomRight,
    );

    var barPaint = Paint()
      ..color = (style?.barColor ?? defaultBarSeriesStyle.barColor)!
      ..shader = (style?.gradient ?? defaultBarSeriesStyle.gradient)
          ?.toShader(bar.outerRect);

    var barStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = (style?.strokeWidth ?? defaultBarSeriesStyle.strokeWidth)!
      ..color = (style?.strokeColor ?? defaultBarSeriesStyle.strokeColor)!;

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
  }

  void _drawBarValues(
    Canvas canvas,
    CartesianChartPainter chart,
    BarData data,
  ) {
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
  }
}
