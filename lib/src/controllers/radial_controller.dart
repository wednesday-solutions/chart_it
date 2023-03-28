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

class RadialController extends ChangeNotifier
    with RadialDataMixin, ChartAnimationsMixin<RadialSeries> {
  final Map<RadialSeries, RadialConfig> _seriesConfigs = {};
  final Map<Type, RadialPainter> painters = {};

  @override
  double minValue = 0.0;
  @override
  double maxValue = 0.0;

  List<RadialSeries> currentData = List.empty();
  List<RadialSeries> targetData;

  // Animation Variables
  @override
  late List<Tween<RadialSeries>> tweenSeries;
  @override
  final AnimationController animation;
  @override
  final bool animateOnLoad;
  @override
  final bool animateOnUpdate;

  // Values to keep updating when scrolling
  Offset? pointer;

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
}
