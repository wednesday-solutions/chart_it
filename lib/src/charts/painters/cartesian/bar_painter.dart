import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/extensions/interactions.dart';
import 'package:chart_it/src/extensions/paint_objects.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

class BarPainter implements CartesianPainter<BarInteractionResult> {
  final List<_BarInteractionData> _interactionData = List.empty(growable: true);

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
    required CartesianPaintingGeometryData chart,
    required CartesianConfig config,
    required CartesianChartStylingData style,
  }) {
    assert(
      config is BarSeriesConfig,
      "$BarPainter required $BarSeriesConfig but found ${config.runtimeType}",
    );
    _interactionData.clear();

    final unitWidth =
        (useGraphUnits ? chart.graphUnitWidth : chart.valueUnitWidth) /
            chart.xUnitValue;

    final data = _BarPainterData(
      series: lerpSeries as BarSeries,
      config: config as BarSeriesConfig,
      vRatio: chart.graphPolygon.height / chart.unitData.totalYRange,
      unitWidth: unitWidth,
      graphUnitWidth: chart.graphUnitWidth,
      valueUnitWidth: chart.valueUnitHeight,
      barWidth: unitWidth / config.maxBarsInGroup,
    );
    _data = data;

    var dx = 0.0; // where to start drawing bars on X-axis
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
          _drawStackedBars(
            group: group,
            groupIndex: i,
            canvas: canvas,
            chart: chart,
            dxOffset: dx,
            style: style,
            data: data,
          );
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

      dx += unitWidth;
    }
  }

  _drawSimpleBar({
    required SimpleBar group,
    required int groupIndex,
    required Canvas canvas,
    required CartesianPaintingGeometryData chart,
    required double dxOffset,
    required CartesianChartStylingData style,
    required _BarPainterData data,
  }) {
    // Precedence take like this
    // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
    var barStyle = group.yValue.barStyle ??
        group.style ??
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
      dxPos: dxOffset + (data.unitWidth * 0.5) - (data.barWidth * 0.5),
      dyPos: chart.axisOrigin.dy,
      barWidth: data.barWidth,
      leftPadding: group.padding,
      rightPadding: group.padding,
      data: data,
    );
    // Finally paint the y-labels for this bar
    _drawBarValues(
      canvas: canvas,
      chart: chart,
      barData: group.yValue,
      data: data,
      dx: dxOffset,
    );
  }

  _drawBarSeries({
    required MultiBar group,
    required int groupIndex,
    required Canvas canvas,
    required CartesianPaintingGeometryData chart,
    required double dxOffset,
    required CartesianChartStylingData style,
    required _BarPainterData data,
  }) {
    // var groupWidth = _unitWidth / group.yValues.length;
    // Draw individual bars in this group
    var groupCount = group.yValues.length; // No. of groups for this multibar
    // Start Offset
    var x =
        dxOffset + (data.unitWidth * 0.5) - (data.barWidth * groupCount * 0.5);
    final padding = group.padding;
    final spacing = group.spacing;

    for (var i = 0; i < groupCount; i++) {
      final barData = group.yValues[i];
      // Precedence take like this
      // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
      var barStyle = barData.barStyle ??
          group.style ??
          data.series.seriesStyle ??
          defaultBarSeriesStyle;

      final leftPadding = i == 0 ? padding : spacing / 2;
      final rightPadding = i == groupCount - 1 ? padding : spacing / 2;

      _drawBar(
        barGroup: group,
        barGroupIndex: groupIndex,
        barData: barData,
        barDataIndex: i,
        canvas: canvas,
        chart: chart,
        style: barStyle,
        // dx pos to start the bar in this group
        dxPos: x,
        dyPos: chart.axisOrigin.dy,
        barWidth: data.barWidth,
        leftPadding: leftPadding,
        rightPadding: rightPadding,
        data: data,
      );
      // Finally paint the y-labels for this bar
      _drawBarValues(
        canvas: canvas,
        chart: chart,
        barData: barData,
        data: data,
        dx: x,
      );

      x += data.barWidth;
    }
  }

  _drawStackedBars({
    required MultiBar group,
    required int groupIndex,
    required Canvas canvas,
    required CartesianPaintingGeometryData chart,
    required double dxOffset,
    required CartesianChartStylingData style,
    required _BarPainterData data,
  }) {
    var stackCount = group.yValues.length; // No. of bars for this stack

    // Start Vertical Offset
    var positiveYPos = chart.axisOrigin.dy, negativeYPos = chart.axisOrigin.dy;

    for (var i = 0; i < stackCount; i++) {
      final barData = group.yValues[i];
      final verticalHeight = barData.yValue * data.vRatio;
      // Precedence take like this
      // barStyle > groupStyle > seriesStyle > defaultSeriesStyle
      var barStyle = barData.barStyle ??
          group.style ??
          data.series.seriesStyle ??
          defaultBarSeriesStyle;

      // Since we have only one yValue, we only have to draw one bar
      _drawBar(
        barGroup: group,
        barGroupIndex: groupIndex,
        barData: barData,
        barDataIndex: i,
        canvas: canvas,
        chart: chart,
        style: barStyle,
        // dx pos to start the bar from
        dxPos: dxOffset + (data.unitWidth * 0.5) - (data.barWidth * 0.5),
        // dy pos to increase the height as the bars stack
        dyPos: barData.yValue.isNegative ? negativeYPos : positiveYPos,
        barWidth: data.barWidth,
        leftPadding: group.padding,
        rightPadding: group.padding,
        data: data,
      );
      // Finally paint the y-labels for this bar
      _drawBarValues(
        canvas: canvas,
        chart: chart,
        barData: barData,
        data: data,
        dx: dxOffset,
      );

      if (!barData.yValue.isNegative) {
        positiveYPos -= verticalHeight;
      } else {
        // If value is negative then height needs to increase
        // because to go into negative axis, the height needs to be incremented from axis origin
        negativeYPos += verticalHeight;
      }
    }
  }

  _drawBar({
    required BarGroup barGroup,
    required int barGroupIndex,
    required BarData barData,
    required int barDataIndex,
    required Canvas canvas,
    required CartesianPaintingGeometryData chart,
    BarDataStyle? style,
    required double dxPos,
    required double dyPos,
    required double barWidth,
    required double leftPadding,
    required double rightPadding,
    required _BarPainterData data,
  }) {
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

    var strokeWidthOffset = (style?.strokeWidth ?? 0) * 0.5;

    var bar = RRect.fromLTRBAndCorners(
      dxPos + leftPadding + strokeWidthOffset, // start X + padding
      dyPos - y + strokeWidthOffset, // axisOrigin's dY - yValue
      dxPos + barWidth - rightPadding - strokeWidthOffset, // startX + barWidth
      dyPos - strokeWidthOffset, // axisOrigin's dY
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

  void _drawBarValues({
    required Canvas canvas,
    required CartesianPaintingGeometryData chart,
    required BarData barData,
    required _BarPainterData data,
    required double dx,
  }) {
    if (barData.label != null) {
      final textPainter = ChartTextPainter.fromChartTextStyle(
        text: barData.label!(barData.yValue),
        chartTextStyle: barData.labelStyle ?? defaultChartTextStyle,
      );

      textPainter.layout();

      double x = dx;

      switch (barData.labelStyle?.align) {
        case TextAlign.start:
        case TextAlign.left:
          x += textPainter.width;
          break;
        case TextAlign.end:
        case TextAlign.right:
          x += data.barWidth - textPainter.width;
          break;
        case TextAlign.justify:
        case TextAlign.center:
        case null:
          x += data.barWidth / 2;
          break;
      }

      double y = chart.axisOrigin.dy - (barData.yValue * data.vRatio);

      switch (barData.labelPosition) {
        case BarLabelPosition.insideBar:
          y += textPainter.height;
          break;
        case BarLabelPosition.outsideBar:
          y -= textPainter.height;
          break;
      }

      textPainter.paint(
        canvas: canvas,
        offset: Offset(
          x,
          y,
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
        data.graphUnitWidth * widthMultiplicationFactor;

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

  _BarPainterData({
    required this.series,
    required this.config,
    required this.vRatio,
    required this.unitWidth,
    required this.barWidth,
    required this.graphUnitWidth,
    required this.valueUnitWidth,
  });
}
