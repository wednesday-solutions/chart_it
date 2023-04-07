import 'dart:ui';

import 'dart:ui';

import 'dart:ui';

import 'dart:ui';

import 'dart:ui';

import 'dart:ui';

import 'dart:ui';

import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_mixins.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_range.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

/// The Animation and Data Controller for a Cartesian Chart.
///
/// Encapsulates the required Chart Data, Animatable Data, Configs
/// and Mapped Painters for every [CartesianSeries].
class CartesianController extends ChangeNotifier
    with
        // CartesianDataMixin,
        ChartAnimationsMixin<CartesianSeries, CartesianMinMaxData>,
        InteractionDispatcher {
  /// Holds a map of configs for every data series.
  final Map<CartesianSeries, CartesianConfig> cachedConfigs = {};

  /// Holds a map of painters for every series type.
  final Map<int, CartesianPainter> painters = {};

  /// The Current Data which will be lerped across every animation tick.
  List<CartesianSeries> currentData = List.empty();

  /// The Target Data to which the chart needs to updates.
  List<CartesianSeries> targetData;

  CartesianMinMaxData minMaxData = CartesianMinMaxData.zero();

  CartesianMinMaxData targetMinMaxData = CartesianMinMaxData.zero();

  /// Callback to calculate the X & Y ranges after Data Aggregation.
  final CalculateCartesianRange calculateRange;

  /// A List of [Tween] for evaluating every [CartesianSeries] when
  /// the chart animates.
  @override
  late List<Tween<CartesianSeries>> tweenSeries;

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
    required this.targetData,
    required this.animation,
    this.animateOnUpdate = true,
    this.animateOnLoad = true,
    this.rangeContext,
    required this.calculateRange,
  }) {
    animateDataUpdates();
    // On Initialization, we need to animate our chart if necessary
    updateDataSeries(targetData, isInitPhase: true);
  }

  update({
    List<CartesianSeries>? targetData,
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

    if (targetData != null && this.targetData != targetData) {
      updateDataSeries(targetData, isInitPhase: false);
    }
  }

  _invalidateRangeValues() {}

  @override
  CartesianMinMaxData aggregateData(List<CartesianSeries> data) {
    double minXValue = 0;
    double minYValue = 0;
    double maxXValue = 0;
    double maxYValue = 0;

    for (var i = 0; i < data.length; i++) {
      final series = data[i];
      series.when(onBarSeries: (barSeries) {
        // Invalidate Painter for BarSeries
        if (painters.getOrNull(i).runtimeType != BarPainter) {
          painters[i] = BarPainter(useGraphUnits: false);
        } else {
          // Update if needed.
        }

        for (var j = 0; j < barSeries.barData.length; j++) {
          final barGroup = barSeries.barData[j];

          var config = cachedConfigs.getOrNull(barSeries);
          if (config == null) {
            config = BarSeriesConfig();
            cachedConfigs[barSeries] = config;
          }
          assert(config is BarSeriesConfig);
          (config as BarSeriesConfig).updateEdges(barGroup, (minX, maxX, minY, maxY) {
            if (minX < minXValue) {
              minXValue = minX;
            }

            if (maxX > maxXValue) {
              maxXValue = maxX;
            }

            if (minY < minYValue) {
              minYValue = minY;
            }

            if (maxY > maxYValue) {
              maxYValue = maxY;
            }
          });
        }
      });
    }

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

    print("MAX: ${results.maxXRange}");
    return CartesianMinMaxData(
      maxXValue: maxXValue,
      maxYValue: maxYValue,
      minXValue: minXValue,
      minYValue: minYValue,
      maxXRange: results.maxXRange,
      maxYRange: results.maxYRange,
      minXRange: results.minXRange,
      minYRange: results.minYRange,
    );
  }

  @override
  CartesianConfig? getConfig(CartesianSeries series) => cachedConfigs[series];

  @override
  List<Tween<CartesianSeries>> getSeriesTweens({
    required List<CartesianSeries> newSeries,
    required bool isInitPhase,
  }) =>
      toCartesianTweens(
        isInitPhase ? List.empty() : currentData,
        newSeries,
      ) ??
      List.empty();

  @override
  void setAnimatableData(List<CartesianSeries> data,  CartesianMinMaxData minMax) {
    currentData = data;
    minMaxData = minMax;
  }

  @override
  CartesianMinMaxData setData(List<CartesianSeries> data) {
    _resetRangeData();
    targetMinMaxData = aggregateData(data);
    // _invalidateRangeValues();
    targetData = data;
    return targetMinMaxData;
  }

  _updateMinMaxValues(minX, maxX, minY, maxY) {}

  _resetRangeData() {
    // targetMinMaxData = CartesianMinMaxData.zero();
  }

  @override
  void onInteraction(
    ChartInteractionType interactionType,
    Offset localPosition,
  ) {
    // TODO: implement onInteraction
  }

  @override
  Tween<CartesianMinMaxData> getMinMaxTween(CartesianMinMaxData minMaxData, bool isInitPhase) {
    return CartesianMinMaxDataTween(begin: isInitPhase ? targetMinMaxData : this.minMaxData, end: minMaxData);
  }
}

// abstract class ChartPaintingContext<SERIES, CONFIG, PAINTER> {
//   SERIES series;
//   CONFIG config;
//   PAINTER painter;
//
//   ChartPaintingContext({
//     required this.series,
//     required this.config,
//     required this.painter,
//   });
// }
//
// class BarChartPaintingContext
//     extends ChartPaintingContext<BarSeries, BarSeriesConfig, BarPainter> {
//   BarChartPaintingContext({
//     required super.series,
//     required super.config,
//     required super.painter,
//   });
// }

class CartesianMinMaxData {
  /// The maximum value along X-Axis.
  final double maxXValue;

  /// The maximum value along Y-Axis.
  final double maxYValue;

  /// The minimum value along X-Axis.
  final double minXValue;

  /// The minimum value along Y-Axis.
  final double minYValue;

  /// The maximum range across X-Axis.
  final double maxXRange;

  /// The maximum range across Y-Axis.
  final double maxYRange;

  /// The minimum range across X-Axis.
  final double minXRange;

  /// The minimum range across Y-Axis.
  final double minYRange;

  CartesianMinMaxData({
    required this.maxXValue,
    required this.maxYValue,
    required this.minXValue,
    required this.minYValue,
    required this.maxXRange,
    required this.maxYRange,
    required this.minXRange,
    required this.minYRange,
  });

  factory CartesianMinMaxData.zero() => CartesianMinMaxData(
        maxXValue: 0,
        maxYValue: 0,
        minXValue: 0,
        minYValue: 0,
        maxXRange: 0,
        maxYRange: 0,
        minXRange: 0,
        minYRange: 0,
      );

  CartesianMinMaxData copyWith({
    double? maxXValue,
    double? maxYValue,
    double? minXValue,
    double? minYValue,
    double? maxXRange,
    double? maxYRange,
    double? minXRange,
    double? minYRange,
  }) {
    return CartesianMinMaxData(
      maxXValue: maxXValue ?? this.maxXValue,
      maxYValue: maxYValue ?? this.maxYValue,
      minXValue: minXValue ?? this.minXValue,
      minYValue: minYValue ?? this.minYValue,
      maxXRange: maxXRange ?? this.maxXRange,
      maxYRange: maxYRange ?? this.maxYRange,
      minXRange: minXRange ?? this.minXRange,
      minYRange: minYRange ?? this.minYRange,
    );
  }

  @override
  String toString() {
    return 'CartesianMinMaxData{maxXValue: $maxXValue, maxYValue: $maxYValue, minXValue: $minXValue, minYValue: $minYValue, maxXRange: $maxXRange, maxYRange: $maxYRange, minXRange: $minXRange, minYRange: $minYRange}';
  }
}

class CartesianMinMaxDataTween extends Tween<CartesianMinMaxData> {
  CartesianMinMaxDataTween({required CartesianMinMaxData? begin, required CartesianMinMaxData end})
      : super(begin: begin, end: end);

  @override
  CartesianMinMaxData lerp(double t) {
    return CartesianMinMaxData(
        maxXValue: lerpDouble(begin?.maxXValue, end!.maxXValue, t) ?? 0,
        maxYValue: lerpDouble(begin?.maxYValue, end!.maxYValue, t) ?? 0,
        minXValue: lerpDouble(begin?.minXValue, end!.minXValue, t) ?? 0,
        minYValue: lerpDouble(begin?.minYValue, end!.minYValue, t) ?? 0,
        maxXRange: lerpDouble(begin?.maxXRange, end!.maxXRange, t) ?? 0,
        maxYRange: lerpDouble(begin?.maxYRange, end!.maxYRange, t) ?? 0,
        minXRange: lerpDouble(begin?.minXRange, end!.minXRange, t) ?? 0,
        minYRange: lerpDouble(begin?.minYRange, end!.minYRange, t) ?? 0);
  }
}
