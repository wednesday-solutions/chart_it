import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/extensions/paint_objects.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

class BarPainter implements CartesianPainter<BarInteractionResult> {
  final List<_BarInteractionData> _interactionData = List.empty(growable: true);

  late BarSeriesConfig _config;
  BarSeries? _data;

  late double _vRatio;
  late double _unitWidth;
  late double _barWidth;
  bool useGraphUnits;

  late Paint _barPaint;
  late Paint _barStroke;

  BarPainter({required this.useGraphUnits}) {
    print("PAINTERR CREATED");
    _barPaint = Paint();
    _barStroke = Paint()..style = PaintingStyle.stroke;
  }

  @override
  void paint(
    CartesianSeries lerpSeries,
    Canvas canvas,
    CartesianChartPainter chart,
    CartesianConfig config,
  ) {
    assert(
      config is BarSeriesConfig,
      "$BarPainter required $BarSeriesConfig but found ${config.runtimeType}",
    );
    // Remove old Interaction Data
    _interactionData.clear();
    // Setup the bar data
    _data = lerpSeries as BarSeries;
    _config = config as BarSeriesConfig;

    _unitWidth = useGraphUnits ? chart.graphUnitWidth : chart.valueUnitWidth;
    _barWidth = _unitWidth / _config.maxBarsInGroup;
    // We need to compute the RATIO between the chart height (in pixels) and
    // the range of data! This will come in handy later when we have to
    // compute the vertical pixel value for each data point
    _vRatio = chart.graphHeight / chart.totalYRange;

    var dx = chart.axisOrigin.dx; // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    for (var i = 0; i < _data!.barData.length; i++) {
      final group = _data!.barData[i];
      if (group is SimpleBar) {
        // We have to paint a single bar
        _drawSimpleBar(
          group: group,
          groupIndex: i,
          canvas: canvas,
          chart: chart,
          dxOffset: dx,
          seriesStyle: _data!.seriesStyle,
        );
      } else if (group is MultiBar) {
        // We need to find the arrangement of our bar group
        if (group.arrangement == BarGroupArrangement.stack) {
          // TODO: Paint Stacked Bars
        } else {
          // Paint Bar Series across unit width
          _drawBarSeries(
            group: group,
            groupIndex: i,
            canvas: canvas,
            chart: chart,
            dxOffset: dx,
            seriesStyle: _data!.seriesStyle,
          );
        }
      }

      _drawGroupLabel(
        canvas: canvas,
        chart: chart,
        dxOffset: dx,
        group: group,
        labelStyle: _data!.labelStyle,
      );

      dx += _unitWidth;
    }
  }

  @override
  BarInteractionResult? hitTest(
    TouchInteractionType type,
    Offset localPosition,
  ) {
    final data = _data;
    if (data == null) return null;

    if (data.interactionEvents.isEnabled) {
      var snapToNearestBar = data.interactionEvents.snapToNearestBar;
      var fuzziness = data.interactionEvents.fuzziness;

      _BarInteractionData? previousBar;

      for (var i = 0; i < _interactionData.length; i++) {
        final bar = _interactionData[i];

        if (bar.containsWithFuzziness(localPosition, fuzziness)) {
          return bar.getInteractionResult(localPosition, type);
        }

        if (snapToNearestBar) {
          final isLocationAfterBar = bar.isLocationAfterBar(localPosition);
          if (isLocationAfterBar) {
            previousBar = bar;
          } else {
            return _snapToNearestBar(
              previousBar: previousBar,
              currentBar: bar,
              isLastBar: i == _interactionData.length - 1,
              type: type,
              localPosition: localPosition,
                isLocationAfterBar: isLocationAfterBar
            );
          }
        }
      }
    }
    return null;
  }

  _drawSimpleBar({
    required SimpleBar group,
    required int groupIndex,
    required Canvas canvas,
    required CartesianChartPainter chart,
    required double dxOffset,
    required BarDataStyle? seriesStyle,
  }) {
    // Precedence take like this
    // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
    var style =
        group.yValue.barStyle ?? group.groupStyle ?? seriesStyle ?? defaultBarSeriesStyle;

    // Since we have only one yValue, we only have to draw one bar
    _drawBar(
      barGroup: group,
      barGroupIndex: groupIndex,
      barData: group.yValue,
      // BarData index for SimpleBar is always zero
      // because there are no multiple y-Values.
      barDataIndex: 0,
      canvas: canvas,
      chart: chart,
      style: style,
      // dx pos to start the bar from
      dxCenter: dxOffset + (_unitWidth * 0.5) - (_barWidth * 0.5),
      barWidth: _barWidth,
      barSpacing: group.barSpacing,
    );
    // Finally paint the y-labels for this bar
    _drawBarValues(canvas: canvas, chart: chart, data: group.yValue);
  }

  _drawBarSeries({
    required MultiBar group,
    required int groupIndex,
    required Canvas canvas,
    required CartesianChartPainter chart,
    required double dxOffset,
    required BarDataStyle? seriesStyle,
  }) {
    // var groupWidth = _unitWidth / group.yValues.length;
    // Draw individual bars in this group
    var groupCount = group.yValues.length; // No. of groups for this multibar
    // Start Offset
    var x = dxOffset + (_unitWidth * 0.5) - (_barWidth * groupCount * 0.5);

    for (var i = 0; i < groupCount; i++) {
      final barData = group.yValues[i];
      // Precedence take like this
      // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
      var style = barData.barStyle ?? group.groupStyle ?? seriesStyle ?? defaultBarSeriesStyle;

      _drawBar(
        barGroup: group,
        barGroupIndex: groupIndex,
        barData: barData,
        barDataIndex: i,
        canvas: canvas,
        chart: chart,
        style: style,
        // dx pos to start the bar in this group
        dxCenter: x,
        barWidth: _barWidth,
        barSpacing: group.groupSpacing,
      );
      // Finally paint the y-labels for this bar
      _drawBarValues(canvas: canvas, chart: chart, data: barData);

      x += _barWidth;
    }
  }

  _drawBar({
    required BarGroup barGroup,
    required int barGroupIndex,
    required BarData barData,
    required int barDataIndex,
    required Canvas canvas,
    required CartesianChartPainter chart,
    BarDataStyle? style,
    required double dxCenter,
    required double barWidth,
    required double barSpacing,
    // required num yValue,
  }) {
    var padding = (barSpacing * 0.5);
    // The first thing to do is to get the data point into the range!
    // This is because we don't want our bar to exceed the min/max values
    // we then multiply it by the vRatio to get the vertical pixel value!
    var y = barData.yValue * _vRatio;
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
      topLeft: barData.yValue.isNegative ? bottomLeft : topLeft,
      topRight: barData.yValue.isNegative ? bottomRight : topRight,
      bottomLeft: barData.yValue.isNegative ? topLeft : bottomLeft,
      bottomRight: barData.yValue.isNegative ? topRight : bottomRight,
    );

    // Before we Paint this Bar, we need to store it's data for hitTesting
    var shapeData = _BarInteractionData(
      rect: bar,
      barGroup: barGroup,
      barGroupIndex: barGroupIndex,
      barData: barData,
      barDataIndex: barDataIndex,
    );
    _interactionData.add(shapeData);

    // Finally We will Paint our Bar on the Canvas.
    var barPaint = _barPaint
      ..color = (style?.barColor ?? defaultBarSeriesStyle.barColor)!
      ..shader = (style?.gradient ?? defaultBarSeriesStyle.gradient)?.toShader(bar.outerRect);

    canvas.drawRRect(bar, barPaint); // draw fill

    final strokeWidth = style?.strokeWidth;
    if (strokeWidth != null && strokeWidth > 0.0) {
      var barStroke = _barStroke
        ..strokeWidth = strokeWidth
        ..color = (style?.strokeColor ?? defaultBarSeriesStyle.strokeColor)!;
      canvas.drawRRect(bar, barStroke); // draw stroke
    }
  }

  void _drawGroupLabel({
    required Canvas canvas,
    required CartesianChartPainter chart,
    required double dxOffset,
    required BarGroup group,
    required ChartTextStyle? labelStyle,
  }) {
    // We will draw the Label that the user had provided for our bar group
    if (group.label != null) {
      // TODO: rotate the text if it doesn't fit within the unitWidth
      final textPainter = ChartTextPainter.fromChartTextStyle(
        text: group.label!(group.xValue),
        maxWidth: _unitWidth,
        chartTextStyle: group.labelStyle ?? labelStyle ?? defaultChartTextStyle,
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

  void _drawBarValues({
    required Canvas canvas,
    required CartesianChartPainter chart,
    required BarData data,
  }) {
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

  BarInteractionResult _snapToNearestBar({
    required _BarInteractionData? previousBar,
    required _BarInteractionData currentBar,
    required bool isLastBar,
    required TouchInteractionType type,
    required Offset localPosition,
    required bool isLocationAfterBar,
  }) {
    if (previousBar == null || (isLastBar && isLocationAfterBar)) {
      return currentBar.getInteractionResult(localPosition, type);
    }

    final nearestBar = _findNearestBar(localPosition, previousBar, currentBar);
    return nearestBar.getInteractionResult(localPosition, type);
  }

  _BarInteractionData _findNearestBar(
    Offset position,
    _BarInteractionData previous,
    _BarInteractionData current,
  ) {
    final distToPrev = position.dx - previous.rect.right;
    final distToCurrent = current.rect.left - position.dx;
    return distToPrev >= distToCurrent ? current : previous;
  }
}

class _BarInteractionData {
  final RRect rect;
  final BarGroup barGroup;
  final int barGroupIndex;
  final BarData barData;
  final int barDataIndex;

  _BarInteractionData({
    required this.rect,
    required this.barGroup,
    required this.barGroupIndex,
    required this.barData,
    required this.barDataIndex,
  });

  bool containsWithFuzziness(Offset location, double fuzziness) {
    final left = rect.left - fuzziness;
    final right = rect.right + fuzziness;
    final top = rect.top - fuzziness;
    final bottom = rect.bottom + fuzziness;
    return location.dx >= left && location.dx < right && location.dy >= top && location.dy < bottom;
  }

  bool isLocationAfterBar(Offset location) {
    return location.dx > rect.right;
  }

  BarInteractionResult getInteractionResult(Offset localPosition, TouchInteractionType type) {
    return BarInteractionResult(
      barGroup: barGroup,
      barGroupIndex: barGroupIndex,
      barData: barData,
      barDataIndex: barDataIndex,
      localPosition: localPosition,
      interactionType: type,
    );
  }
}
