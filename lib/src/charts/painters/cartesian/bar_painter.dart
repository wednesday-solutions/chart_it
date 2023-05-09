import 'dart:math';

import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/extensions/interactions.dart';
import 'package:chart_it/src/extensions/paint_objects.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

class BarPainter implements CartesianPainter<BarInteractionResult> {
  final List<_BarInteractionData> _interactionData = List.empty(growable: true);
  final _groupLabelTextPainters = <ChartTextPainter?>[];

  _BarPainterData? _data;
  bool useGraphUnits;

  late Paint _barPaint;
  late Paint _barStroke;

  BarPainter({required this.useGraphUnits}) {
    _barPaint = Paint();
    _barStroke = Paint()..style = PaintingStyle.stroke;
  }

  @override
  BarInteractionResult? hitTest(
    TouchInteractionType type,
    Offset localPosition,
  ) {
    final data = _data;
    if (data == null || !data.series.interactionEvents.shouldHitTest) {
      return null;
    }

    // We will perform HitTest only if Interactions are enabled for this series.
    if (data.series.interactionEvents.isEnabled) {
      var snapToBarConfig = data.series.interactionEvents.snapToBarConfig;
      var fuzziness = data.series.interactionEvents.fuzziness;

      _BarInteractionData? previousBar;

      for (var i = 0; i < _interactionData.length; i++) {
        final bar = _interactionData[i];
        final shouldSnapToHeight = snapToBarConfig.shouldSnapToHeight(type);

        if (bar.containsWithFuzziness(
          position: localPosition,
          fuzziness: fuzziness,
          snapToHeight: shouldSnapToHeight,
        )) {
          return bar.getInteractionResult(localPosition, type);
        }

        if (snapToBarConfig.shouldSnapToWidth(type)) {
          final isLastBar = i == _interactionData.length - 1;
          final isPointerAfterBar = bar.isPointerAfterBar(localPosition);
          if (!isPointerAfterBar || isLastBar) {
            switch (snapToBarConfig.snapToBarBehaviour) {
              case SnapToBarBehaviour.snapToNearest:
                return _snapToNearestBar(
                  localPosition: localPosition,
                  fuzziness: fuzziness,
                  type: type,
                  previousBar: previousBar,
                  currentBar: bar,
                  isPointerAfterBar: isPointerAfterBar,
                  isLastBar: isLastBar,
                  shouldSnapToHeight: shouldSnapToHeight,
                );
              case SnapToBarBehaviour.snapToSection:
                return _snapToSectionBar(
                  data: data,
                  localPosition: localPosition,
                  previousBar: previousBar,
                  bar: bar,
                  type: type,
                  fuzziness: fuzziness,
                  isLastBar: isLastBar,
                  shouldSnapToHeight: shouldSnapToHeight,
                );
            }
          } else {
            previousBar = bar;
          }
        }
      }
    }
    // No Interactions for this PieSeries.
    return null;
  }

  @override
  void paint({
    required CartesianSeries<TouchInteractionEvents<TouchInteractionResult>>
        lerpSeries,
    required Canvas canvas,
    required CartesianChartGeometryData chart,
    required CartesianConfig config,
    required CartesianChartStylingData style,
  }) {
    assert(
      config is BarSeriesConfig,
      "$BarPainter required $BarSeriesConfig but found ${config.runtimeType}",
    );
    _interactionData.clear();

    final unitWidth =
        (useGraphUnits ? chart.graphUnitWidth : chart.valueUnitWidth) / chart.xUnitValue;

    final data = _BarPainterData(
      series: lerpSeries as BarSeries,
      config: config as BarSeriesConfig,
      vRatio: chart.graphHeight / chart.totalYRange,
      unitWidth: unitWidth,
      graphUnitWidth: chart.graphUnitWidth,
      valueUnitWidth: chart.valueUnitHeight,
      barWidth: unitWidth / config.maxBarsInGroup,
      graphEdgeInsets: chart.graphEdgeInsets,
    );
    _data = data;

    var dx = chart.axisOrigin.dx; // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    for (var i = 0; i < data.series.barData.length; i++) {
      final group = data.series.barData[i];
      if (group is SimpleBar) {
        // We have to paint a single bar
        _drawSimpleBar(
          group: group,
          groupIndex: i,
          canvas: canvas,
          chart: chart,
          dxOffset: dx,
          style: style,
          data: data,
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
            style: style,
            data: data,
          );
        }
      }

      _drawGroupLabel(
        canvas: canvas,
        chart: chart,
        dxOffset: dx,
        group: group,
        groupIndex: i,
        style: style,
        data: data,
      );

      dx += unitWidth;
    }
  }

  @override
  EdgeInsets performAxisLabelLayout(
      {required CartesianSeries series,
      required CartesianChartStylingData style,
      required double graphUnitWidth,
      required double valueUnitWidth}) {
    assert(series is BarSeries);
    var maxHeight = 0.0;
    for (var i = 0; i < (series as BarSeries).barData.length; i++) {
      final group = series.barData[i];
      if (group.label != null) {
        // TODO: rotate the text if it doesn't fit within the unitWidth
        final painter = ChartTextPainter.fromChartTextStyle(
          text: group.label!(group.xValue),
          maxWidth: useGraphUnits ? graphUnitWidth : valueUnitWidth,
          chartTextStyle:
              group.labelStyle ?? series.labelStyle ?? defaultChartTextStyle,
        )..layout();
        maxHeight = max(maxHeight, painter.height);
        _groupLabelTextPainters.add(painter);
      } else {
        _groupLabelTextPainters.add(null);
      }
    }

    return EdgeInsets.only(
        bottom: maxHeight + style.axisStyle!.tickLength + 15);
  }

  _drawSimpleBar(
      {required SimpleBar group,
      required int groupIndex,
      required Canvas canvas,
      required CartesianChartGeometryData chart,
      required double dxOffset,
      required CartesianChartStylingData style,
      required _BarPainterData data}) {
    // Precedence take like this
    // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
    var barStyle = group.yValue.barStyle ??
        group.groupStyle ??
        data.series.seriesStyle ??
        defaultBarSeriesStyle;

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
      style: barStyle,
      // dx pos to start the bar from
      dxCenter: dxOffset + (data.unitWidth * 0.5) - (data.barWidth * 0.5),
      barWidth: data.barWidth,
      barSpacing: group.barSpacing,
      data: data,
    );
    // Finally paint the y-labels for this bar
    _drawBarValues(
        canvas: canvas,
        chart: chart,
        barData: group.yValue,
        style: style,
        data: data);
  }

  _drawBarSeries(
      {required MultiBar group,
      required int groupIndex,
      required Canvas canvas,
      required CartesianChartGeometryData chart,
      required double dxOffset,
      required CartesianChartStylingData style,
      required _BarPainterData data}) {
    // var groupWidth = _unitWidth / group.yValues.length;
    // Draw individual bars in this group
    var groupCount = group.yValues.length; // No. of groups for this multibar
    // Start Offset
    var x =
        dxOffset + (data.unitWidth * 0.5) - (data.barWidth * groupCount * 0.5);

    for (var i = 0; i < groupCount; i++) {
      final barData = group.yValues[i];
      // Precedence take like this
      // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
      var barStyle = barData.barStyle ??
          group.groupStyle ??
          data.series.seriesStyle ??
          defaultBarSeriesStyle;

      _drawBar(
        barGroup: group,
        barGroupIndex: groupIndex,
        barData: barData,
        barDataIndex: i,
        canvas: canvas,
        chart: chart,
        style: barStyle,
        // dx pos to start the bar in this group
        dxCenter: x,
        barWidth: data.barWidth,
        barSpacing: group.groupSpacing,
        data: data,
      );
      // Finally paint the y-labels for this bar
      _drawBarValues(
          canvas: canvas,
          chart: chart,
          barData: barData,
          style: style,
          data: data);

      x += data.barWidth;
    }
  }

  _drawBar(
      {required BarGroup barGroup,
      required int barGroupIndex,
      required BarData barData,
      required int barDataIndex,
      required Canvas canvas,
      required CartesianChartGeometryData chart,
      BarDataStyle? style,
      required double dxCenter,
      required double barWidth,
      required double barSpacing,
      required _BarPainterData data}) {
    var padding = (barSpacing * 0.5);
    // The first thing to do is to get the data point into the range!
    // This is because we don't want our bar to exceed the min/max values
    // we then multiply it by the vRatio to get the vertical pixel value!
    var y = barData.yValue * data.vRatio;

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
      ..shader = (style?.gradient ?? defaultBarSeriesStyle.gradient)
          ?.toShader(bar.outerRect);

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
    required CartesianChartGeometryData chart,
    required double dxOffset,
    required BarGroup group,
    required CartesianChartStylingData style,
    required _BarPainterData data,
    required int groupIndex,
  }) {
    // We will draw the Label that the user had provided for our bar group
    if (group.label != null) {
      final textPainter = _groupLabelTextPainters[groupIndex];
      textPainter?.paint(
        canvas: canvas,
        offset: Offset(
          dxOffset + (data.unitWidth * 0.5),
          chart.graphPolygon.bottom + style.axisStyle!.tickLength + 15,
        ),
      );
    }
  }

  void _drawBarValues(
      {required Canvas canvas,
      required CartesianChartGeometryData chart,
      required BarData barData,
      required CartesianChartStylingData style,
      required _BarPainterData data}) {
    if (barData.label != null) {
      final textPainter = ChartTextPainter.fromChartTextStyle(
        text: barData.label!(barData.yValue),
        chartTextStyle: barData.labelStyle ?? defaultChartTextStyle,
      );

      textPainter.paint(
        canvas: canvas,
        offset: Offset(
          chart.graphPolygon.left - style.axisStyle!.tickLength - 15,
          chart.axisOrigin.dy - (barData.yValue * data.vRatio),
        ),
      );
    }
  }

  BarInteractionResult? _snapToNearestBar({
    required Offset localPosition,
    required Fuzziness fuzziness,
    required TouchInteractionType type,
    required _BarInteractionData? previousBar,
    required _BarInteractionData currentBar,
    required bool isPointerAfterBar,
    required bool isLastBar,
    required bool shouldSnapToHeight,
  }) {
    if (previousBar == null || (isLastBar && isPointerAfterBar)) {
      return currentBar.getInteractionResult(localPosition, type);
    }

    final nearestBar = _findNearestBar(localPosition, previousBar, currentBar);

    // If snap to height is disabled and pointer is above the nearest bar, return null
    if (!shouldSnapToHeight &&
        nearestBar.isPointerAboveBar(
            position: localPosition, fuzziness: fuzziness)) {
      return null;
    }

    return nearestBar.getInteractionResult(localPosition, type);
  }

  BarInteractionResult? _snapToSectionBar(
      {required _BarPainterData data,
      required Offset localPosition,
      required _BarInteractionData? previousBar,
      required _BarInteractionData bar,
      required TouchInteractionType type,
      required Fuzziness fuzziness,
      required bool isLastBar,
      required bool shouldSnapToHeight}) {
    final index = previousBar?.barGroupIndex ?? bar.barGroupIndex;
    final widthMultiplicationFactor = index + 1;
    final currentUnitWidthEndOffset =
        (data.graphUnitWidth * widthMultiplicationFactor) +
            data.graphEdgeInsets.left;

    if (localPosition.dx <= currentUnitWidthEndOffset) {
      if (previousBar?.barGroupIndex == bar.barGroupIndex) {
        return _snapToNearestBar(
          localPosition: localPosition,
          fuzziness: fuzziness,
          type: type,
          previousBar: previousBar,
          currentBar: bar,
          isPointerAfterBar: false,
          isLastBar: isLastBar,
          shouldSnapToHeight: shouldSnapToHeight,
        );
      }

      return previousBar?.getInteractionResult(localPosition, type) ??
          bar.getInteractionResult(localPosition, type);
    } else {
      return bar.getInteractionResult(localPosition, type);
    }
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

  bool containsWithFuzziness({
    required Offset position,
    required Fuzziness fuzziness,
    required bool snapToHeight,
  }) {
    final left = rect.left - fuzziness.left;
    final right = rect.right + fuzziness.right;

    if (snapToHeight) {
      // If snapToHeight is true, any value of dy should return true. So we just check for dx constraints.
      return position.dx >= left && position.dx < right;
    }

    final top = rect.top - fuzziness.top;
    final bottom = rect.bottom + fuzziness.bottom;
    return position.dx >= left &&
        position.dx < right &&
        position.dy >= top &&
        position.dy < bottom;
  }

  bool isPointerAfterBar(Offset position) => position.dx > rect.right;

  bool isPointerAboveBar(
      {required Offset position, required Fuzziness fuzziness}) {
    final top = rect.top - fuzziness.top;
    final bottom = rect.bottom + fuzziness.bottom;

    return position.dy < top || position.dy > bottom;
  }

  BarInteractionResult getInteractionResult(
    Offset localPosition,
    TouchInteractionType type,
  ) {
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

class _BarPainterData {
  final BarSeries series;
  final BarSeriesConfig config;

  // We need to compute the RATIO between the chart height (in pixels) and
  // the range of data! This will come in handy later when we have to
  // compute the vertical pixel value for each data point
  final double vRatio;
  final double unitWidth;
  final double barWidth;
  final double graphUnitWidth;
  final double valueUnitWidth;
  final EdgeInsets graphEdgeInsets;

  _BarPainterData({
    required this.series,
    required this.config,
    required this.vRatio,
    required this.unitWidth,
    required this.barWidth,
    required this.graphUnitWidth,
    required this.valueUnitWidth,
    required this.graphEdgeInsets,
  });
}
