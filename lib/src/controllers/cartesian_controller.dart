import 'dart:math';

import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_range.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/state/bar_series_state.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/data/pair.dart';
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

  // Values to keep updating when scrolling
  Offset? pointer;

  CartesianRangeContext? rangeContext;

  /// The Animation and Data Controller for a Cartesian Chart.
  ///
  /// Encapsulates the required Chart Data, Animatable Data, Configs
  /// and Mapped Painters for every [CartesianSeries].
  CartesianController({
    required this.data,
    required this.animation,
    this.animateOnUpdate = true,
    this.animateOnLoad = true,
    this.rangeContext,
    required this.calculateRange,
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
    CartesianRangeContext? rangeContext,
  }) {
    if (rangeContext != null && this.rangeContext != rangeContext) {
      this.rangeContext = rangeContext;
    }

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
      updateDataSeries(data, isInitPhase: false);
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
    if (results.minYRange.isNegative) {
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
    var minYValue = 0.0;
    // Set our State holder
    var states = <PaintingState>[];

    for (var i = 0; i < newData.length; i++) {
      final series = newData[i];
      series.when(
        onBarSeries: (barSeries) {
          // Invalidate Painter for BarSeries
          var painter = BarPainter(useGraphUnits: false);
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
      );
    }

    // Invalidate the RangeData
    var results = _invalidateRange(maxXValue, maxYValue, minXValue, minYValue);
    return CartesianData(states: states, range: results);
  }

  @override
  Pair<CartesianData, bool> setData(List<CartesianSeries> data) {
    // Get the cacheKey as a List of our CartesianSeries.
    var cacheKey = EquatableList<CartesianSeries>(data);

    if (_cachedValues.containsKey(cacheKey)) {
      // Cache entry found. Just return the CartesianData for this Series.
      targetData = _cachedValues[cacheKey]!;
      return targetData.to(true);
    } else {
      // No entry found, so this is probably a new series. We need to recalculate
      targetData = constructState(data);
      // Garbage Collection for cache. We cannot hold too much in it forever.
      if (_cachedValues.keys.length >= 100) _cachedValues.clear();
      // Update the cache with new data
      _cachedValues[cacheKey] = targetData;
      return targetData.to(false);
    }
  }

  @override
  void setAnimatableData(CartesianData data) => currentData = data;

  @override
  Tween<CartesianData> getTweens({
    required CartesianData newData,
    required bool isInitPhase,
  }) =>
      CartesianDataTween(
        begin: isInitPhase ? CartesianData.zero(newData.range) : currentData,
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
