import 'dart:math';

import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_mixins.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_range.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/material.dart';

/// The Animation and Data Controller for a Cartesian Chart.
///
/// Encapsulates the required Chart Data, Animatable Data, Configs
/// and Mapped Painters for every [CartesianSeries].
class CartesianController extends ChangeNotifier
    with CartesianDataMixin, ChartAnimationsMixin<CartesianSeries> {
  /// Holds a map of configs for every data series.
  final Map<CartesianSeries, CartesianConfig> _seriesConfigs = {};

  /// Holds a map of painters for every series type.
  final Map<Type, CartesianPainter> painters = {};

  /// The Current Data which will be lerped across every animation tick.
  List<CartesianSeries> currentData = List.empty();

  /// The Target Data to which the chart needs to updates.
  List<CartesianSeries> targetData;

  /// Callback to calculate the X & Y ranges after Data Aggregation.
  final CalculateCartesianRange calculateRange;

  /// The maximum value along X-Axis.
  @override
  double maxXValue = 0.0;

  /// The maximum value along Y-Axis.
  @override
  double maxYValue = 0.0;

  /// The minimum value along X-Axis.
  @override
  double minXValue = 0.0;

  /// The minimum value along Y-Axis.
  @override
  double minYValue = 0.0;

  /// The maximum range across X-Axis.
  @override
  double maxXRange = 0.0;

  /// The maximum range across Y-Axis.
  @override
  double maxYRange = 0.0;

  /// The minimum range across X-Axis.
  @override
  double minXRange = 0.0;

  /// The minimum range across Y-Axis.
  @override
  double minYRange = 0.0;

  /// A List of [Tween] for evaluating every [CartesianSeries] when
  /// the chart animates.
  @override
  late List<Tween<CartesianSeries>> tweenSeries;

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

  /// The Animation and Data Controller for a Cartesian Chart.
  ///
  /// Encapsulates the required Chart Data, Animatable Data, Configs
  /// and Mapped Painters for every [CartesianSeries].
  CartesianController({
    required this.targetData,
    required this.animation,
    this.animateOnUpdate = true,
    this.animateOnLoad = true,
    required this.calculateRange,
  }) {
    animateDataUpdates();
    // On Initialization, we need to animate our chart if necessary
    updateDataSeries(targetData, isInitPhase: true);
  }

  bool shouldRepaint(CartesianController changedValue) {
    if (minXValue != changedValue.minXValue ||
        maxXValue != changedValue.maxXValue ||
        minYValue != changedValue.minYValue ||
        maxYValue != changedValue.maxYValue ||
        minXRange != changedValue.minXRange ||
        maxXRange != changedValue.maxXRange ||
        minYRange != changedValue.minYRange ||
        maxYRange != changedValue.maxYRange ||
        pointer != changedValue.pointer) return true;

    return false;
  }

  _invalidatePainters(List<CartesianSeries> data) {
    // For every distinct Cartesian Series, we will construct a painter for it
    data.distinctTypes().forEach((series) {
      painters.createAndUpdate(series, onCreate: () {
        return CartesianSeries.whenType(
          series,
          onBarSeries: () => BarPainter(useGraphUnits: false),
          orElse: () {
            throw ArgumentError('No Painter defined for this type: $series');
          },
        );
      });
    });
  }

  _invalidateRangeValues() {
    var rangeCtx = CartesianRangeContext(
      maxX: maxXValue,
      maxY: maxYValue,
      minX: minXValue,
      minY: minYValue,
    );
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

    minXRange = results.minXRange;
    maxXRange = results.maxXRange;
    minYRange = results.minYRange;
    maxYRange = results.maxYRange;
  }

  @override
  void aggregateData(List<CartesianSeries> data) {
    _resetRangeData();
    // How many times we may need to iterate over our data
    var iterations = data.maxIterations();
    for (var i = 0; i < iterations; i++) {
      // iterate over the n'th index of every series
      for (var j = 0; j < data.length; j++) {
        final series = data[j];
        series.when(
          onBarSeries: (series) {
            if (i < series.barData.length) {
              // We Know the index. We have to get the min/max values
              //  from the 'i'th element (BarGroup) in this series
              _seriesConfigs.createAndUpdate(
                series,
                onCreate: () => BarSeriesConfig(),
                onUpdate: (config) {
                  var barConfig = config.asOrNull<BarSeriesConfig>();
                  // Run the min & max calculations
                  barConfig?.updateEdges(
                    series.barData[i],
                    (minX, maxX, minY, maxY) {
                      minXValue = min(minXValue, minX);
                      maxXValue = max(maxXValue, maxX);
                      minYValue = min(minYValue, minY);
                      maxYValue = max(maxYValue, maxY);
                    },
                  );
                },
              );
            }
          },
        );
      }
    }
    // Finally we are ready to calculate the ranges
    _invalidateRangeValues();
  }

  @override
  CartesianConfig? getConfig(CartesianSeries series) => _seriesConfigs[series];

  @override
  List<Tween<CartesianSeries>> getTweens({
    required List<CartesianSeries> newSeries,
    required bool isInitPhase,
  }) =>
      toCartesianTweens(
        isInitPhase ? List.empty() : currentData,
        newSeries,
      ) ??
      List.empty();

  @override
  void setAnimatableData(List<CartesianSeries> data) => currentData = data;

  @override
  void setData(List<CartesianSeries> data) {
    _invalidatePainters(data);
    aggregateData(data);
    targetData = data;
  }

  _resetRangeData() {
    maxXValue = 0.0;
    maxYValue = 0.0;
    minXValue = 0.0;
    minYValue = 0.0;
    maxXRange = 0.0;
    maxYRange = 0.0;
    minXRange = 0.0;
    minYRange = 0.0;
  }
}
