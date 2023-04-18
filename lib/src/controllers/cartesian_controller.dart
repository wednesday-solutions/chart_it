import 'dart:math';

import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_range.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/state/bar_series_state.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
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
  final Map<Set<CartesianSeries>, CartesianData> _cachedValues = {};

  List<CartesianSeries> data;

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
    return CartesianData(state: states, range: results);
  }

  @override
  CartesianData setData(List<CartesianSeries> data) {
    // Get the cacheKey as a Set of our CartesianSeries.
    Set<CartesianSeries> cacheKey = Set.from(data);

    if (_cachedValues.containsKey(cacheKey)) {
      // Cache entry found. Just return the CartesianData for this Series.
      targetData = _cachedValues[cacheKey]!;
    } else {
      // No entry found, so this is probably a new series. We need to recalculate
      targetData = constructState(data);
      // Reset the old cache. Update the cache with new data
      _cachedValues.clear();
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
        begin: isInitPhase ? CartesianData.zero(newData.range) : currentData,
        end: newData,
      );

  @override
  void onInteraction(
    TouchInteractionType interactionType,
    Offset localPosition,
  ) {
    // TODO: implement onInteraction
    switch (interactionType) {
      case TouchInteractionType.tap:
        // Fire all painters to perform Hit Test

        break;
      case TouchInteractionType.doubleTap:
        // TODO: Handle this case.
        break;
      case TouchInteractionType.dragStart:
        // TODO: Handle this case.
        break;
      case TouchInteractionType.dragUpdate:
        // TODO: Handle this case.
        break;
      case TouchInteractionType.dragEnd:
        // TODO: Handle this case.
        break;
    }
  }
}
