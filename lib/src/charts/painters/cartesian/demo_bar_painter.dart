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

// TODO: Rewrite the hitTest interaction logic, based on BarGroup
// 1. Update the way we store interaction areas for each bar.
// 2. Update looping through each group
// 3. For positive interaction between two groups, perform the following logic
// SimpleBar <> Multibar (series): Normal logic
// SimpleBar <> Multibar (stack): Specialised logic
// MultiBar(series) <> Multibar (stack): Specialised logic
class DemoBarPainter implements CartesianPainter<BarInteractionResult> {
  final List<_BarInteractionData> _interactionData = List.empty(growable: true);
  final List<_BarGroupInteractionWrapper> _groupInteractions =
      List.empty(growable: true);

  _BarPainterData? _data;
  bool useGraphUnits;

  late Paint _barPaint;
  late Paint _barStroke;

  DemoBarPainter({required this.useGraphUnits}) {
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

      _BarGroupInteractionWrapper previousGroup;
      // _BarInteractionData? previousBar;

      for (var i = 0; i < _groupInteractions.length; i++) {
        final isLastGroup = i == _groupInteractions.length - 1;
        final group = _groupInteractions[i];

        if (group.isInteractionWithinBounds(localPosition)) {
          // Our pointer is in this current group. Need to find closest interactable bar in this group itself.
          final shouldSnapToHeight = snapToBarConfig.shouldSnapToHeight(type);

          // FIXME: It doesn't really makes sense to iterate into every single bar here
          // FIXME: but we then can't do fuzziness without iterated into every single bar.
          // FIXME: For snapping, even if we find the nearest bar between two bars, we shouldn't exit for the loop, but go through the other bars as well.
          for (var j = 0; j < group.barInteractions.length; j++) {
            final bar = group.barInteractions[j];

            // Step 1: Check with Fuzziness
            if (bar.containsWithFuzziness(
              position: localPosition,
              fuzziness: fuzziness,
              snapToHeight: shouldSnapToHeight,
            )) {
              return bar.getInteractionResult(localPosition, type);
            }

            // Step 2: Check with Snapping
            if (snapToBarConfig.shouldSnapToWidth(type)) {
              switch (snapToBarConfig.snapToBarBehaviour) {
                // case SnapToBarBehaviour.snapToNearest:
                //   {
                //     // If config is snapToNearest, then we must find the closest bar to the pointer in current & previous group
                //     return _snapToNearestBar(
                //       localPosition: localPosition,
                //       fuzziness: fuzziness,
                //       type: type,
                //       previousBar: previousBar,
                //       currentBar: currentBar,
                //       isPointerAfterBar: isPointerAfterBar,
                //       isLastBar: isLastBar,
                //       shouldSnapToHeight: shouldSnapToHeight,
                //     );
                //   }
                case SnapToBarBehaviour.snapToSection:
                  {
                    // If config is SnapToSection, then we must find the closest bar to the pointer in current group
                    // No need to look into the bar data of previous group.
                    return _snapToSectionBar(
                      localPosition: localPosition,
                      currentGroup: group,
                      data: data,
                      type: type,
                      fuzziness: fuzziness,
                      shouldSnapToHeight: shouldSnapToHeight,
                    );
                  }
                default:
                  return null;
              }
            }
          }
        } else if (!group.isPointerAfterCurrentGroup(localPosition) ||
            isLastGroup) {
        } else {
          previousGroup = group;
        }
      }
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
      "$DemoBarPainter required $BarSeriesConfig but found ${config.runtimeType}",
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
          // Paint Stacked Bars
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

    final barInteractions = <_BarInteractionData>[];
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
    final groupInteraction = _BarGroupInteractionWrapper(
      groupStart: dxPos,
      groupEnd: dxPos + data.barWidth,
      type: GroupType.simpleBar,
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
    final barInteractions = <_BarInteractionData>[];
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
    final groupInteraction = _BarGroupInteractionWrapper(
      groupStart: groupStart,
      groupEnd: x,
      // dxOffset + data.unitWidth,
      type: GroupType.multiBarSeries,
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
    final barInteractions = <_BarInteractionData>[];
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
    final groupInteraction = _BarGroupInteractionWrapper(
      groupStart: dxPos,
      groupEnd: dxPos + data.barWidth,
      type: GroupType.multiBarStack,
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
    required Function(_BarInteractionData) onShapeDimensionsReady,
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
    onShapeDimensionsReady(shapeData);
    // _interactionData.add(shapeData);

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

      textPainter.paint(canvas: canvas, offset: Offset(x, y));
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

    final nearestBar =
        _findNearestBarWithDx(localPosition, previousBar, currentBar);

    // If snap to height is disabled and pointer is above the nearest bar, return null
    if (!shouldSnapToHeight &&
        nearestBar.isPointerAboveBar(
          position: localPosition,
          fuzziness: fuzziness,
        )) {
      return null;
    }

    return nearestBar.getInteractionResult(localPosition, type);
  }

  BarInteractionResult? _snapToSectionBar({
    required _BarGroupInteractionWrapper currentGroup,
    required _BarPainterData data,
    required Offset localPosition,
    // required _BarInteractionData? previousBar,
    // required _BarInteractionData bar,
    required TouchInteractionType type,
    required Fuzziness fuzziness,
    // required bool isLastBar,
    required bool shouldSnapToHeight,
  }) {
    // If we are snapping to section, then we only need to find the nearest bar in the current group.
    // Here, it is important we know what is the group type of our current group
    switch (currentGroup.type) {
      case GroupType.simpleBar:
        {
          // Only one bar will be in this group. We should return that
          final bar = currentGroup.barInteractions[0];
          return bar.getInteractionResult(localPosition, type);
        }
      case GroupType.multiBarSeries:
        {
          // TODO: We need to find the nearest bar with dx
          _findNearestBarWithDx(localPosition, previousBar, current);
        }
        break;
      case GroupType.multiBarStack:
        {
          // TODO: We need to find the nearest bar with dy
          _findNearestBarWithDy(localPosition, previous, current);
        }
        break;
    }
  }

  _BarInteractionData _findNearestBarWithDx(
    Offset position,
    _BarInteractionData previous,
    _BarInteractionData current,
  ) {
    final distToPrev = position.dx - previous.rect.right;
    final distToCurrent = current.rect.left - position.dx;
    return distToPrev >= distToCurrent ? current : previous;
  }

  _BarInteractionData _findNearestBarWithDy(
    Offset position,
    _BarInteractionData previous,
    _BarInteractionData current,
  ) {
    // We have two scenarios over here
    // 1.  The pointer is alongside the bar.
    // 2. The pointer is over the top most bar.
    final previousHeightBounds = _isWithinHeightBounds(position, previous);
    final currentHeightBounds = _isWithinHeightBounds(position, current);

    if (previousHeightBounds || currentHeightBounds) {
      // Pointer is alongside the bar
      return currentHeightBounds ? current : previous;
    } else {
      // Pointer is on the top most bar
      // in this case, we need to find the closest bar by the nearest top side of the bar
      final distToPrev = position.dy - previous.rect.top;
      final distToCurrent = position.dy - current.rect.top;
      return distToPrev >= distToCurrent ? current : previous;
    }
  }

  bool _isWithinHeightBounds(Offset position, _BarInteractionData bar) {
    return bar.rect.top <= position.dy && bar.rect.bottom >= position.dy;
  }
}

enum GroupType { simpleBar, multiBarSeries, multiBarStack }

class _BarGroupInteractionWrapper {
  final double groupStart;
  final double groupEnd;
  final GroupType type;
  final int groupIndex;
  final List<_BarInteractionData> barInteractions;

  _BarGroupInteractionWrapper({
    required this.groupStart,
    required this.groupEnd,
    required this.type,
    required this.groupIndex,
    required this.barInteractions,
  });

  bool isPointerAfterCurrentGroup(Offset position) => position.dx > groupEnd;

  bool isInteractionWithinBounds(Offset localPosition) {
    return groupStart <= localPosition.dx && groupEnd >= localPosition.dx;
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

  bool isPointerAboveBar({
    required Offset position,
    required Fuzziness fuzziness,
  }) {
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
