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

    var dx = 0.0; // where to start drawing bars on X-axis
    // We will draw each group and their individual bars
    for (var i = 0; i < data.series.candles.length; i++) {
      // TODO: Paint each bar individually

      dx += unitWidth;
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
