import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_grid_units.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/candle_stick_painter.dart';
import 'package:chart_it/src/charts/state/bar_series_state.dart';
import 'package:chart_it/src/charts/state/candle_stick_series_state.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

/// The Animation and Data Controller for a Cartesian Chart.
///
/// Encapsulates the required Chart Data, Animatable Data, Configs
/// and Mapped Painters for every [CartesianSeries].
class CartesianController extends ChangeNotifier
    with
        ChartAnimationsMixin<CartesianData, CartesianSeries>,
        InteractionDispatcher {
  final Map<EquatableList<CartesianSeries>, CartesianData> _cachedValues = {};

  final List<CartesianSeries> data;

  final bool enforceOriginsWithZero;

  /// The Current Data which will be lerped across every animation tick.
  late CartesianData currentData;

  /// The Target Data to which the chart needs to updates.
  late CartesianData targetData;

  /// Callback to calculate the X & Y ranges after Data Aggregation.
  final CalculateCartesianRange calculateRange;

  /// A [Tween] for evaluating every [CartesianSeries] when the chart animates.
  @override
  late Tween<CartesianData> tweenData;

  /// The Animation Controller to drive the charts animations.
  @override
  AnimationController animation;

  /// Sets if the chart should animate or not, when loaded for the first time.
  /// Defaults to true.
  @override
  bool animateOnLoad;

  /// Sets if the chart should animate or not, when the data is updated.
  /// Defaults to true.
  @override
  bool animateOnUpdate;

  CartesianChartStructureData structureData;
  CartesianChartStylingData stylingData;

  /// The Animation and Data Controller for a Cartesian Chart.
  ///
  /// Encapsulates the required Chart Data, Animatable Data, Configs
  /// and Mapped Painters for every [CartesianSeries].
  CartesianController({
    required this.data,
    required this.animation,
    this.animateOnUpdate = true,
    this.animateOnLoad = true,
    this.enforceOriginsWithZero = true,
    required this.calculateRange,
    required this.structureData,
    required this.stylingData,
  }) {
    animateDataUpdates();
    // On Initialization, we need to animate our chart if necessary
    updateDataSeries(data, isInitPhase: true);
  }

  update({
    List<CartesianSeries>? data,
    AnimationController? animation,
    bool? animateOnUpdate,
    bool? animateOnLoad,
    required CartesianChartStructureData structureData,
    required CartesianChartStylingData stylingData,
  }) {
    if (animateOnLoad != null && this.animateOnLoad != animateOnLoad) {
      this.animateOnLoad = animateOnLoad;
    }

    if (animateOnUpdate != null && this.animateOnUpdate != animateOnUpdate) {
      this.animateOnUpdate = animateOnUpdate;
    }

    if (animation != null && this.animation != animation) {
      this.animation = animation;
      animateDataUpdates();
    }

    if (data != null && this.data != data) {
      final oldStyle = this.stylingData;
      final oldStructure = this.structureData;
      this.structureData = structureData;
      this.stylingData = stylingData;
      updateDataSeries(
        data,
        isInitPhase: false,
        forceUpdate: oldStructure != structureData || oldStyle != stylingData,
      );
    }
  }

  CartesianRangeResult _invalidateRange(
    double maxX,
    double maxY,
    double minX,
    double minY,
  ) {
    var rangeCtx = CartesianRangeContext(maxX, maxY, minX, minY);
    var results = calculateRange(rangeCtx);

    while (results.maxYRange % results.yUnitValue != 0) {
      results.maxYRange = results.maxYRange.round().toDouble();
      results.maxYRange++;
    }

    // We need to check for negative y values
    if (!enforceOriginsWithZero || results.minYRange.isNegative) {
      while (results.minYRange % results.yUnitValue != 0) {
        results.minYRange = results.minYRange.round().toDouble();
        results.minYRange--;
      }
    } else {
      // No negative y values, so min will be zero
      results.minYRange = 0.0;
    }

    return results;
  }

  @override
  CartesianData constructState(List<CartesianSeries> newData) {
    // Set our Range Holders
    var maxXValue = 0.0;
    var maxYValue = 0.0;
    var minXValue = 0.0;
    var minYValue = double.infinity;
    // Set our State holder
    var states = <PaintingState>[];

    for (var i = 0; i < newData.length; i++) {
      final series = newData[i];
      series.when(
        onBarSeries: (barSeries) {
          // Invalidate Painter for BarSeries
          var painter = BarPainter(useGraphUnits: true);
          var config = BarSeriesConfig();

          updateInteractionDetectionStates(barSeries.interactionEvents);

          config.calcBarDataRange(barSeries.barData, (minX, maxX, minY, maxY) {
            minXValue = min(minX, minXValue);
            maxXValue = max(maxX, maxXValue);
            minYValue = min(minY, minYValue);
            maxYValue = max(maxY, maxYValue);
          });

          states.add(
            BarSeriesState(data: barSeries, config: config, painter: painter),
          );
        },
        onCandleStickSeries: (candleSticks) {
          // Invalidate Painter for CandleStick Series
          var painter = CandleStickPainter(useGraphUnits: true);
          var config = CandleStickSeriesConfig();

          updateInteractionDetectionStates(candleSticks.interactionEvents);

          config.calcHighLowRange(candleSticks.candles, (minAmt, maxAmt, timeStamp){
            // TODO: The amount will be Y values and Dates will be X values
            minXValue = min(timeStamp.toDouble(), minXValue);
            maxXValue = max(timeStamp.toDouble(), maxXValue);
            minYValue = min(minAmt, minYValue);
            maxYValue = max(maxAmt, maxYValue);
          });

          states.add(
            CandleStickState(data: candleSticks, config: config, painter: painter),
          );
        }
      );
    }

    // Invalidate the RangeData
    var rangeResult = _invalidateRange(maxXValue, maxYValue, minXValue, minYValue);

    final totalXRange = rangeResult.maxXRange - rangeResult.minXRange;
    final xUnitsCount = totalXRange / structureData.xUnitValue;

    final totalYRange = rangeResult.maxYRange - rangeResult.minYRange;
    final yUnitsCount = totalYRange / structureData.yUnitValue;

    final gridUnitData = CartesianGridUnitsData(
      xUnitValue: rangeResult.xUnitValue.toDouble(),
      xUnitsCount: xUnitsCount,
      yUnitValue: rangeResult.yUnitValue.toDouble(),
      yUnitsCount: yUnitsCount,
      totalXRange: totalXRange,
      totalYRange: totalYRange,
      maxXRange: rangeResult.maxXRange,
      maxYRange: rangeResult.maxYRange,
      minXRange: rangeResult.minXRange,
      minYRange: rangeResult.minYRange,
    );

    return CartesianData(
      states: states,
      gridUnitsData: gridUnitData,
    );
  }

  @override
  CartesianData setData(List<CartesianSeries> data, bool forceUpdate) {
    // Get the cacheKey as a List of our CartesianSeries.
    var cacheKey = EquatableList<CartesianSeries>(data);

    if (_cachedValues.containsKey(cacheKey) && !forceUpdate) {
      // Cache entry found. Just return the CartesianData for this Series.
      targetData = _cachedValues[cacheKey]!;
    } else {
      // No entry found, so this is probably a new series. We need to recalculate
      targetData = constructState(data);
      // Garbage Collection for cache. We cannot hold too much in it forever.
      if (_cachedValues.keys.length >= 100) _cachedValues.clear();
      // Update the cache with new data
      _cachedValues[cacheKey] = targetData;
    }
    return targetData;
  }

  @override
  void setAnimatableData(CartesianData data) => currentData = data;

  @override
  Tween<CartesianData> getTweens({
    required CartesianData newData,
    required bool isInitPhase,
  }) =>
      CartesianDataTween(
        begin: isInitPhase
            ? CartesianData.zero(
                gridUnitsData:
                    newData.gridUnitsData.copyWith(isInitState: true),
              )
            : currentData,
        end: newData,
      );

  @override
  void onInteraction(
    TouchInteractionType interactionType,
    Offset localPosition,
  ) {
    // Fire all painters to perform Hit Test
    for (var i = 0; i < targetData.states.length; i++) {
      final state = targetData.states[i];
      if (state is BarSeriesState) {
        var result = state.painter.hitTest(interactionType, localPosition);
        if (result != null) state.data.interactionEvents.onInteraction(result);
      }
    }
  }
}
