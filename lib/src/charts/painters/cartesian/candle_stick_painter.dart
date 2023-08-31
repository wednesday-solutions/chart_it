import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/candle_sticks.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/interactors/cartesian/bar_hit_tester.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

class CandleStickPainter implements CartesianPainter<BarInteractionResult> {
  final List<BarGroupInteractionData> _groupInteractions =
  List.empty(growable: true);

  _CandleStickPainterData? _data;
  bool useGraphUnits;

  late Paint _barPaint;
  late Paint _barStroke;
  // late double _candleWidth;
  // late double _low;
  // late double _high;
  // late double _close;
  // late Color _bullColor;
  // late Color _bearColor;

  CandleStickPainter({required this.useGraphUnits}) {
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
      barWidth: unitWidth / 10,
    );
    _data = data;

    var dxOffset = const Offset(0, 0); // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    for (var i = 0; i < data.series.candles.length; i++) {
      final candle = data.series.candles[i];
      // TODO: Paint each bar individually

      // paintCandle(canvas, dxOffset, i, candle);
      dxOffset += Offset(unitWidth, 0);
    }
  }

  /// draws a single candle
  // void paintCandle(Canvas canvas, Offset offset, int index, Candle candle) {
  //   Color color = candle.isBull ? _bullColor : _bearColor;
  //
  //   Paint paint = Paint()
  //     ..color = color
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = 1;
  //
  //   double x = size.width + offset.dx - (index + 0.5) * _candleWidth;
  //
  //   canvas.drawLine(
  //     Offset(x, offset.dy + (_high - candle.high) / range),
  //     Offset(x, offset.dy + (_high - candle.low) / range),
  //     paint,
  //   );
  //
  //   final double openCandleY = offset.dy + (_high - candle.open) / range;
  //   final double closeCandleY = offset.dy + (_high - candle.close) / range;
  //
  //   if ((openCandleY - closeCandleY).abs() > 1) {
  //     canvas.drawLine(
  //       Offset(x, openCandleY),
  //       Offset(x, closeCandleY),
  //       paint..strokeWidth = _candleWidth * 0.8,
  //     );
  //   } else {
  //     // if the candle body is too small
  //     final double mid = (closeCandleY + openCandleY) / 2;
  //     canvas.drawLine(
  //       Offset(x, mid - 0.5),
  //       Offset(x, mid + 0.5),
  //       paint..strokeWidth = _candleWidth * 0.8,
  //     );
  //   }
  // }
}

class _CandleStickPainterData {
  final CandleStickSeries series;
  final CandleStickSeriesConfig config;

  // We need to compute the RATIO between the chart height (in pixels) and
  // the range of data! This will come in handy later when we have to
  // compute the vertical pixel value for each data point
  final double vRatio;
  final double unitWidth;
  final double barWidth;
  final double graphUnitWidth;
  final double valueUnitWidth;

  _CandleStickPainterData({
    required this.series,
    required this.config,
    required this.vRatio,
    required this.unitWidth,
    required this.barWidth,
    required this.graphUnitWidth,
    required this.valueUnitWidth,
  });
}
