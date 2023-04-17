import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_mixins.dart';
import 'package:chart_it/src/charts/data/pie/pie_series.dart';
import 'package:chart_it/src/charts/painters/radial/pie_painter.dart';
import 'package:chart_it/src/charts/painters/radial/radial_painter.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

/// The Animation and Data Controller for a Radial Chart.
///
/// Encapsulates the required Chart Data, Animatable Data, Configs
/// and Mapped Painters for every [RadialSeries].
class RadialController extends ChangeNotifier
    with
        RadialDataMixin,
        // ChartAnimationsMixin<RadialSeries>,
        InteractionDispatcher {
  /// Holds a map of configs for every data series.
  final Map<RadialSeries, RadialConfig> cachedConfigs = {};

  /// Holds a map of painters for every series type.
  final Map<int, RadialPainter> painters = {};

  /// The Current Data which will be lerped across every animation tick.
  List<RadialSeries> currentData = List.empty();

  /// The Target Data to which the chart needs to updates.
  List<RadialSeries> targetData;

  /// The minimum value across all Series.
  @override
  double minValue = 0.0;

  /// The maximum value across all Series.
  @override
  double maxValue = 0.0;

  /// A List of [Tween] for evaluating every [RadialSeries] when
  /// the chart animates.
  @override
  late List<Tween<RadialSeries>> tweenSeries;

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
    required this.targetData,
    required this.animation,
    this.animateOnUpdate = true,
    this.animateOnLoad = true,
  }) {
    // animateDataUpdates();
    // // On Initialization, we need to animate our chart if necessary
    // updateDataSeries(targetData, isInitPhase: true);
  }

  update({
    List<RadialSeries>? targetData,
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
      // animateDataUpdates();
    }

    if (targetData != null && this.targetData != targetData) {
      // updateDataSeries(targetData, isInitPhase: false);
    }
  }

  @override
  void aggregateData(List<RadialSeries> data) {
    for (var i = 0; i < data.length; i++) {
      final series = data[i];
      series.when(
        onPieSeries: (pieSeries) {
          // invalidate painter for PieSeries
          if (painters.getOrNull(i).runtimeType != PiePainter) {
            painters[i] = PiePainter();
          } else {
            // Update if needed.
          }

          for (var j = 0; j < pieSeries.slices.length; j++) {
            final slice = pieSeries.slices[j];

            var config = cachedConfigs.getOrNull(pieSeries);
            if (config == null) {
              config = PieSeriesConfig();
              cachedConfigs[pieSeries] = config;
            }
            assert(config is PieSeriesConfig);
            (config as PieSeriesConfig).updateEdges(slice, _updateMinMaxValues);
          }
        },
      );
    }
    // We cannot show Negative Values in Radial Charts, so for now
    // We will throw exception if either of min or max values are negative
    // FIXME: SUBJECT TO CHANGE
    if (minValue.isNegative || maxValue.isNegative) {
      throw ArgumentError('Radial Charts cannot display Negative Values!');
    }
  }

  @override
  RadialConfig? getConfig(RadialSeries series) => cachedConfigs[series];

  @override
  List<Tween<RadialSeries>> getTweens({
    required List<RadialSeries> newSeries,
    required bool isInitPhase,
  }) =>
      toRadialTweens(
        isInitPhase ? List.empty() : currentData,
        newSeries,
      ) ??
      List.empty();

  @override
  void setAnimatableData(List<RadialSeries> data) => currentData = data;

  @override
  void setData(List<RadialSeries> data) {
    _resetRangeData();
    aggregateData(data);
    targetData = data;
  }

  _updateMinMaxValues(value) {
    if (value < minValue) {
      minValue = value;
    }

    if (value > maxValue) {
      maxValue = value;
    }
  }

  _resetRangeData() {
    minValue = 0.0;
    maxValue = 0.0;
  }

  @override
  void onInteraction(
    TouchInteractionType interactionType,
    Offset localPosition,
  ) {
    // TODO: implement onInteraction
  }
}
