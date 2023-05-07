import 'dart:math';

import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';
import 'package:chart_it/src/charts/data/pie/pie_series.dart';
import 'package:chart_it/src/charts/painters/radial/pie_painter.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/charts/state/pie_series_state.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

/// The Animation and Data Controller for a Radial Chart.
///
/// Encapsulates the required Chart Data, Animatable Data, Configs
/// and Mapped Painters for every [RadialSeries].
class RadialController extends ChangeNotifier
    with ChartAnimationsMixin<RadialData, RadialSeries>, InteractionDispatcher {
  final Map<EquatableList<RadialSeries>, RadialData> _cachedValues = {};

  final List<RadialSeries> data;

  /// The Current Data which will be lerped across every animation tick.
  late RadialData currentData;

  /// The Target Data to which the chart needs to updates.
  late RadialData targetData;

  /// A [Tween] for evaluating every [RadialSeries] when the chart animates.
  @override
  late Tween<RadialData> tweenData;

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

  /// The Animation and Data Controller for a Radial Chart.
  ///
  /// Encapsulates the required Chart Data, Animatable Data, Configs
  /// and Mapped Painters for every [RadialSeries].
  RadialController({
    required this.data,
    required this.animation,
    this.animateOnUpdate = true,
    this.animateOnLoad = true,
  }) {
    animateDataUpdates();
    // // On Initialization, we need to animate our chart if necessary
    updateDataSeries(data, isInitPhase: true);
  }

  update({
    List<RadialSeries>? data,
    AnimationController? animation,
    bool? animateOnUpdate,
    bool? animateOnLoad,
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
      updateDataSeries(data, isInitPhase: false);
    }
  }

  @override
  RadialData constructState(List<RadialSeries> newData) {
    // Set our Range Holders
    var minValue = 0.0;
    var maxValue = 0.0;
    // Set our State holder
    var states = <PaintingState>[];

    for (var i = 0; i < newData.length; i++) {
      final series = newData[i];
      series.when(
        onPieSeries: (pieSeries) {
          // Invalidate Painter for PieSeries
          var painter = PiePainter();
          var config = PieSeriesConfig();

          updateInteractionDetectionStates(pieSeries.interactionEvents);

          config.calcSliceRange(pieSeries.slices, (value) {
            minValue = min(value, minValue);
            maxValue = max(value, maxValue);
          });

          states.add(
            PieSeriesState(data: pieSeries, config: config, painter: painter),
          );
        },
      );
    }

    // We cannot show Negative Values in Radial Charts, so for now
    // We will throw exception if either of min or max values are negative
    // FIXME: SUBJECT TO CHANGE
    if (minValue.isNegative || maxValue.isNegative) {
      throw ArgumentError('Radial Charts cannot display Negative Values!');
    }

    return RadialData(states: states);
  }

  @override
  RadialData setData(List<RadialSeries> data) {
    // Get the cacheKey as a List of our CartesianSeries.
    var cacheKey = EquatableList<RadialSeries>(data);

    if (_cachedValues.containsKey(cacheKey)) {
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
  void setAnimatableData(RadialData data) => currentData = data;

  @override
  Tween<RadialData> getTweens({
    required RadialData newData,
    required bool isInitPhase,
  }) =>
      RadialDataTween(
        begin: isInitPhase ? RadialData.zero() : currentData,
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
      if (state is PieSeriesState) {
        var result = state.painter.hitTest(interactionType, localPosition);
        if (result != null) state.data.interactionEvents.onInteraction(result);
      }
    }
  }
}
