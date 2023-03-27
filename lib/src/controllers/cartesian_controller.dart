import 'dart:math';

import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
import 'package:chart_it/src/extensions/data_mixins.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/material.dart';

class CartesianController extends ChangeNotifier
    with
        CartesianDataMixin<CartesianSeries>,
        ChartAnimationsMixin<CartesianSeries> {
  final Map<CartesianSeries, CartesianConfig> _seriesConfigs = {};
  final Map<Type, CartesianPainter> painters = {};

  List<CartesianSeries> currentData = List.empty();
  List<CartesianSeries> targetData;

  final Function(CartesianController controller) rangeConstraints;

  @override
  double maxXValue = 0.0;
  @override
  double maxYValue = 0.0;
  @override
  double minXValue = 0.0;
  @override
  double minYValue = 0.0;
  @override
  double maxXRange = 0.0;
  @override
  double maxYRange = 0.0;
  @override
  double minXRange = 0.0;
  @override
  double minYRange = 0.0;

  // Animation Variables
  @override
  late List<Tween<CartesianSeries>> tweenSeries;
  @override
  final AnimationController animation;
  @override
  final bool animateOnLoad;
  @override
  final bool autoAnimate;

  // Values to keep updating when scrolling
  Offset? pointer;

  CartesianController({
    required this.targetData,
    required this.animation,
    this.animateOnLoad = true,
    this.autoAnimate = true,
    required this.rangeConstraints,
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

  void invalidatePainters(List<CartesianSeries> data) {
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

  @override
  void aggregateData(List<CartesianSeries> data) {
    // How many times we may need to iterate over our data
    var iterations = data.maxIterations();
    for (var i = 0; i < iterations; i++) {
      // iterate over the n'th index of every series
      for (var series in data) {
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
    // At this point, we have setup our min/max values across all the data
    // Finally we are ready to calculate the ranges
    rangeConstraints(this);
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
    invalidatePainters(data);
    aggregateData(data);
    targetData = data;
  }
}
