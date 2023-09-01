import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/candle_sticks.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_grid_units.dart';
import 'package:chart_it/src/charts/interactors/cartesian/bar_hit_tester.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

class CandleStickPainter implements CartesianPainter<BarInteractionResult> {
  final List<BarGroupInteractionData> _groupInteractions =
      List.empty(growable: true);

  _CandleStickPainterData? _data;
  bool useGraphUnits;

  late Paint _bullPaint;
  late Paint _bearPaint;
  late Paint _bullStroke;
  late Paint _bearStroke;

  CandleStickPainter({required this.useGraphUnits}) {
    const bullColor = Color(0xFF1CBC91);
    const bearColor = Color(0xFFF05536);

    _bullPaint = Paint()..color = bullColor;
    _bearPaint = Paint()..color = bearColor;

    _bullStroke = Paint()
      ..color = bullColor
      ..style = PaintingStyle.stroke;

    _bearStroke = Paint()
      ..color = bearColor
      ..style = PaintingStyle.stroke;
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

      // return BarHitTester.hitTest(
      //   graphUnitWidth: data.graphUnitWidth,
      //   localPosition: localPosition,
      //   type: type,
      //   interactionData: _groupInteractions,
      //   snapToBarConfig: snapToBarConfig,
      //   fuzziness: fuzziness,
      // );
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
    _groupInteractions.clear();

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
      final barWidth = data.unitWidth * 0.8;

      // Paint each bar individually
      _paintCandle(
        dxPos: x,
        dyPos: chart.axisOrigin.dy,
        barWidth: barWidth,
        canvas: canvas,
        candle: candle,
        unitData: chart.unitData,
        data: data,
      );
      // canvas.save();
      // canvas.restore();

      x += data.unitWidth;
    }
  }

  _paintCandle({
    required double dxPos,
    required double dyPos,
    required double barWidth,
    required Canvas canvas,
    required Candle candle,
    required CartesianGridUnitsData unitData,
    required _CandleStickPainterData data,
  }) {
    var dxOffset = dxPos + (data.unitWidth * 0.5);
    // TODO: First we have to determine if we have to paint red candle or green candle!!
    // If Closing is greater than Opening price, IT IS GREEN!! i.e. profit
    // If Closing is lower than Opening price, IT IS RED!! i.e. loss

    var isBull = candle.close > candle.open;
    // var isBear = candle.close < candle.open;

    // Above condition will determine their paint color. Now we have to draw the candles.
    // This will be done in two steps.
    // 1. Draw Line for High & Low
    final highDy = (candle.high - unitData.minYRange) * data.vRatio;
    var highOffset = Offset(dxOffset, dyPos - highDy);

    final lowDy = (candle.low - unitData.minYRange) * data.vRatio;
    var lowOffset = Offset(dxOffset, dyPos - lowDy);
    canvas.drawLine(
      highOffset,
      lowOffset,
      (isBull ? _bullStroke : _bearStroke)..strokeWidth = data.unitWidth * 0.1,
    );
    // 2. Draw Rectangle for Open and Close.
    final openDy = (candle.open - unitData.minYRange) * data.vRatio;
    final closeDy = (candle.close - unitData.minYRange) * data.vRatio;
    var body = Rect.fromLTRB(
      dxPos + (data.unitWidth * 0.5) - (barWidth * 0.5),
      dyPos - openDy,
      dxPos + (data.unitWidth * 0.5) + (barWidth * 0.5),
      dyPos - closeDy,
    );
    canvas.drawRect(body, isBull ? _bullPaint : _bearPaint);
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
