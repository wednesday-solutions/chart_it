import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/interactors/cartesian/bar_hit_tester.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/extensions/paint_objects.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

class BarPainter implements CartesianPainter<BarInteractionResult> {
  final List<BarGroupInteractionData> _groupInteractions =
      List.empty(growable: true);

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

    if (data.series.interactionEvents.isEnabled) {
      var snapToBarConfig = data.series.interactionEvents.snapToBarConfig;
      var fuzziness = data.series.interactionEvents.fuzziness;

      return BarHitTester.hitTest(
        graphUnitWidth: data.graphUnitWidth,
        localPosition: localPosition,
        type: type,
        interactionData: _groupInteractions,
        snapToBarConfig: snapToBarConfig,
        fuzziness: fuzziness,
      );
    }
    // No Interactions for this BarSeries.
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
    _groupInteractions.clear();

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

    final barInteractions = <BarInteractionData>[];
    final dxPos = dxOffset + (data.unitWidth * 0.5) - (data.barWidth * 0.5);

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
      dxPos: dxPos,
      dyPos: chart.axisOrigin.dy,
      barWidth: data.barWidth,
      leftPadding: group.padding,
      rightPadding: group.padding,
      data: data,
      onShapeDimensionsReady: (interactionData) {
        barInteractions.add(interactionData);
      },
    );
    // Finally paint the y-labels for this bar
    _drawBarValues(
      canvas: canvas,
      chart: chart,
      barData: group.yValue,
      data: data,
      dx: dxOffset,
    );
    // Before we move on to the next group, we have to save the interaction data for this group
    final groupInteraction = BarGroupInteractionData(
      groupStart: dxPos,
      groupEnd: dxPos + data.barWidth,
      type: InteractedGroupType.simpleBar,
      groupIndex: groupIndex,
      barInteractions: barInteractions,
    );
    _groupInteractions.add(groupInteraction);
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
    final barInteractions = <BarInteractionData>[];
    // var groupWidth = _unitWidth / group.yValues.length;
    // Draw individual bars in this group
    var groupCount = group.yValues.length; // No. of groups for this multibar
    // Start Offset
    var x =
        dxOffset + (data.unitWidth * 0.5) - (data.barWidth * groupCount * 0.5);
    final groupStart = x;
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
        onShapeDimensionsReady: (interactionData) {
          barInteractions.add(interactionData);
        },
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
    // Before we move on to the next group, we have to save the interaction data for this group
    final groupInteraction = BarGroupInteractionData(
      groupStart: groupStart,
      groupEnd: x,
      type: InteractedGroupType.multiBarSeries,
      groupIndex: groupIndex,
      barInteractions: barInteractions,
    );
    _groupInteractions.add(groupInteraction);
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
    final barInteractions = <BarInteractionData>[];
    var stackCount = group.yValues.length; // No. of bars for this stack

    final dxPos = dxOffset + (data.unitWidth * 0.5) - (data.barWidth * 0.5);
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
        dxPos: dxPos,
        // dy pos to increase the height as the bars stack
        dyPos: barData.yValue.isNegative ? negativeYPos : positiveYPos,
        barWidth: data.barWidth,
        leftPadding: group.padding,
        rightPadding: group.padding,
        data: data,
        onShapeDimensionsReady: (interactionData) {
          barInteractions.add(interactionData);
        },
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
    // Before we move on to the next group, we have to save the interaction data for this group
    final groupInteraction = BarGroupInteractionData(
      groupStart: dxPos,
      groupEnd: dxPos + data.barWidth,
      type: InteractedGroupType.multiBarStack,
      groupIndex: groupIndex,
      barInteractions: barInteractions,
    );
    _groupInteractions.add(groupInteraction);
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
    required Function(BarInteractionData) onShapeDimensionsReady,
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
    var shapeData = BarInteractionData(
      rect: bar,
      barGroup: barGroup,
      barGroupIndex: barGroupIndex,
      barData: barData,
      barDataIndex: barDataIndex,
    );
    onShapeDimensionsReady(shapeData);

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
