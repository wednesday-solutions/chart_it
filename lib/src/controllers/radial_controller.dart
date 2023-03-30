import 'dart:math';

import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_mixins.dart';
import 'package:chart_it/src/charts/data/pie/pie_series.dart';
import 'package:chart_it/src/charts/painters/radial/pie_painter.dart';
import 'package:chart_it/src/charts/painters/radial/radial_painter.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/material.dart';

/// The Animation and Data Controller for a Radial Chart.
///
/// Encapsulates the required Chart Data, Animatable Data, Configs
/// and Mapped Painters for every [RadialSeries].
class RadialController extends ChangeNotifier
    with RadialDataMixin, ChartAnimationsMixin<RadialSeries> {
  /// Holds a map of configs for every data series.
  final Map<RadialSeries, RadialConfig> _seriesConfigs = {};

  /// Holds a map of painters for every series type.
  final Map<Type, RadialPainter> painters = {};

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
  final AnimationController animation;

  /// Sets if the chart should animate or not, when loaded for the first time.
  /// Defaults to true.
  @override
  final bool animateOnLoad;

  /// Sets if the chart should animate or not, when the data is updated.
  /// Defaults to true.
  @override
  final bool animateOnUpdate;

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
    animateDataUpdates();
    // On Initialization, we need to animate our chart if necessary
    updateDataSeries(targetData, isInitPhase: true);
  }

  bool shouldRepaint(RadialController changedValue) {
    if (maxValue != changedValue.maxValue ||
        minValue != changedValue.minValue ||
        pointer != changedValue.pointer) return true;

    return false;
  }

  _invalidatePainters(List<RadialSeries> data) {
    // For every distinct Cartesian Series, we will construct a painter for it
    data.distinctTypes().forEach((series) {
      painters.createAndUpdate(series, onCreate: () {
        return RadialSeries.whenType(
          series,
          onPieSeries: () => PiePainter(),
          orElse: () {
            throw ArgumentError('No Painter defined for this type: $series');
          },
        );
      });
    });
  }

  @override
  void aggregateData(List<RadialSeries> data) {
    _resetMinMaxValues();
    // How many times we may need to iterate over our data
    var iterations = data.maxIterations();
    for (var i = 0; i < iterations; i++) {
      // iterate over the n'th index of every series
      for (var series in data) {
        series.when(
          onPieSeries: (series) {
            if (i < series.slices.length) {
              // We Know the index. We have to get the min/max values
              //  from the 'i'th element (BarGroup) in this series
              _seriesConfigs.createAndUpdate(
                series,
                onCreate: () => PieSeriesConfig(),
                onUpdate: (config) {
                  var barConfig = config.asOrNull<PieSeriesConfig>();
                  // Run the min & max calculations
                  barConfig?.updateEdges(series.slices[i], (value) {
                    minValue = min(minValue, value);
                    maxValue = max(maxValue, value);
                  });
                },
              );
            }
          },
        );
      }
    }
    // We cannot show Negative Values in Radial Charts, so for now
    // We will throw exception if either of min or max values are negative
    // FIXME: SUBJECT TO CHANGE
    if (minValue.isNegative || maxValue.isNegative) {
      throw ArgumentError('Radial Charts cannot display Negative Values!');
    }
  }

  @override
  RadialConfig? getConfig(RadialSeries series) => _seriesConfigs[series];

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
    _invalidatePainters(data);
    targetData = data;
  }

  _resetMinMaxValues() {
    minValue = 0.0;
    maxValue = 0.0;
  }
}
