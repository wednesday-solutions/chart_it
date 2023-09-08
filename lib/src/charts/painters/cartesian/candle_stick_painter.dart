import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/candle_sticks.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_grid_units.dart';
import 'package:chart_it/src/charts/interactors/cartesian/candle_hit_tester.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

enum _CandleType { bull, bear, neutral }

class CandleStickPainter implements CartesianPainter<CandleInteractionResult> {
  final List<CandleStickInteractionData> _interactionData =
      List.empty(growable: true);

  final defStyle = defaultCandleSticksStyle;

  _CandleStickPainterData? _data;
  bool useGraphUnits;

  late Paint _bodyPaint;
  late Paint _wickPaint;

  CandleStickPainter({required this.useGraphUnits}) {
    _bodyPaint = Paint();
    _wickPaint = Paint()..style = PaintingStyle.stroke;
  }

  @override
  CandleInteractionResult? hitTest(
    TouchInteractionType type,
    Offset localPosition,
  ) {
    final data = _data;
    if (data == null || !data.series.interactionEvents.shouldHitTest) {
      return null;
    }

    if (data.series.interactionEvents.isEnabled) {
      var fuzziness = data.series.interactionEvents.fuzziness;

      return CandleStickHitTester.hitTest(
        graphUnitWidth: data.graphUnitWidth,
        localPosition: localPosition,
        type: type,
        interactionData: _interactionData,
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
      config is CandleStickSeriesConfig,
      "$CandleStickPainter required $CandleStickSeriesConfig but found ${config.runtimeType}",
    );
    _interactionData.clear();

    final unitWidth =
        (useGraphUnits ? chart.graphUnitWidth : chart.valueUnitWidth) /
            chart.xUnitValue;

    final data = _CandleStickPainterData(
      series: lerpSeries as CandleStickSeries,
      config: config as CandleStickSeriesConfig,
      vRatio: chart.graphPolygon.height / chart.unitData.totalYRange,
      unitWidth: unitWidth,
      graphUnitWidth: chart.graphUnitWidth,
      valueUnitWidth: chart.valueUnitHeight,
    );
    _data = data;

    var x = 0.0; // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    for (var i = 0; i < data.series.candles.length; i++) {
      final candle = data.series.candles[i];

      // Paint each bar individually
      _paintCandle(
        dxPos: x,
        dyPos: chart.axisOrigin.dy,
        canvas: canvas,
        candle: candle,
        unitData: chart.unitData,
        data: data,
        style: style,
      );

      x += data.unitWidth;
    }
  }

  _paintCandle({
    required double dxPos,
    required double dyPos,
    required Canvas canvas,
    required Candle candle,
    required CartesianGridUnitsData unitData,
    required _CandleStickPainterData data,
    required CartesianChartStylingData style,
  }) {
    var dxOffset = dxPos + (data.unitWidth * 0.5);
    // Precedence take like this
    // seriesStyle > candleStyle > defaultSeriesStyle
    var style = candle.candleStyle ?? data.series.seriesStyle ?? defStyle;

    var bodyPaint = _getBodyPaint(candle, style);
    var wickPaint = _getWickPaint(candle, style);
    wickPaint
      ..strokeWidth = (style.wickWidth ?? defStyle.wickWidth)!
      ..strokeCap = (style.roundedTips ?? defStyle.roundedTips)!
          ? StrokeCap.round
          : StrokeCap.square;
    // Above methods will determine their paint color. Now we have to draw the candles.
    // This will be done in two steps.
    // 1. Draw Line for High & Low
    final highDy = (candle.high - unitData.minYRange) * data.vRatio;
    var highOffset = Offset(dxOffset, dyPos - highDy);

    final lowDy = (candle.low - unitData.minYRange) * data.vRatio;
    var lowOffset = Offset(dxOffset, dyPos - lowDy);
    canvas.drawLine(highOffset, lowOffset, wickPaint);

    // 2. Draw Rectangle for Open and Close.
    var barWidth = data.unitWidth * (style.bodyWidth ?? defStyle.bodyWidth)!;

    final openDy = (candle.open - unitData.minYRange) * data.vRatio;
    final closeDy = (candle.close - unitData.minYRange) * data.vRatio;
    var body = Rect.fromLTRB(
      dxPos + (data.unitWidth * 0.5) - (barWidth * 0.5),
      dyPos - openDy,
      dxPos + (data.unitWidth * 0.5) + (barWidth * 0.5),
      dyPos - closeDy,
    );
    canvas.drawRect(body, bodyPaint);
    // Before we move onto the next candle, we need to save the rectangle data for this candle
    final candleData = CandleStickInteractionData(
      rect: Rect.fromLTRB(body.left, highOffset.dy, body.left, lowOffset.dy),
      candle: candle,
    );
    _interactionData.add(candleData);
  }

  Paint _getBodyPaint(Candle candle, CandleStyle style) {
    var type = _getCandleType(candle);
    switch (type) {
      case _CandleType.bull:
        return _bodyPaint..color = (style.bullColor ?? defStyle.bullColor)!;
      case _CandleType.bear:
        return _bodyPaint..color = (style.bearColor ?? defStyle.bearColor)!;
      case _CandleType.neutral:
        return _bodyPaint
          ..color = (style.neutralColor ?? defStyle.neutralColor)!;
    }
  }

  Paint _getWickPaint(Candle candle, CandleStyle style) {
    var type = _getCandleType(candle);
    switch (type) {
      case _CandleType.bull:
        return _wickPaint..color = (style.bullColor ?? defStyle.bullColor)!;
      case _CandleType.bear:
        return _wickPaint..color = (style.bearColor ?? defStyle.bearColor)!;
      case _CandleType.neutral:
        return _wickPaint
          ..color = (style.neutralColor ?? defStyle.neutralColor)!;
    }
  }

  _CandleType _getCandleType(Candle candle) {
    if (candle.close > candle.open) {
      return _CandleType.bull;
    } else if (candle.close < candle.open) {
      return _CandleType.bear;
    } else if (candle.close == candle.open) {
      return _CandleType.neutral;
    } else {
      throw ArgumentError('Invalid Candle Type');
    }
  }
}

class _CandleStickPainterData {
  final CandleStickSeries series;
  final CandleStickSeriesConfig config;

  // We need to compute the RATIO between the chart height (in pixels) and
  // the range of data! This will come in handy later when we have to
  // compute the vertical pixel value for each data point
  final double vRatio;
  final double unitWidth;
  final double graphUnitWidth;
  final double valueUnitWidth;

  _CandleStickPainterData({
    required this.series,
    required this.config,
    required this.vRatio,
    required this.unitWidth,
    required this.graphUnitWidth,
    required this.valueUnitWidth,
  });
}
