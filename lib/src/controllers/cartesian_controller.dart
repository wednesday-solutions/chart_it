import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_mixins.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_range.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/state/bar_series_state.dart';
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
        CartesianDataMixin,
        ChartAnimationsMixin<CartesianData, CartesianSeries>,
        InteractionDispatcher {
  /// Holds a map of configs for every data series.
  final Map<CartesianSeries, CartesianConfig> cachedConfigs = {};

  /// Holds a map of painters for every series type.
  final Map<int, CartesianPainter> painters = {};

  /// The Current Data which will be lerped across every animation tick.
  List<CartesianSeries> currentData = List.empty();

  /// The Target Data to which the chart needs to updates.
  List<CartesianSeries> targetData;

  /// Callback to calculate the X & Y ranges after Data Aggregation.
  final CalculateCartesianRange calculateRange;

  late CartesianData currData;

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

  CartesianRangeResult _invalidateRangeValues() {
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

    return results;
  }

  @override
  CartesianData constructState(List<CartesianSeries> newData) {
    // TODO: New Data is our target data.
    var states = <PaintingState>[];

    for (var i = 0; i < newData.length; i++) {
      final series = newData[i];
      series.when(onBarSeries: (barSeries) {
        // Invalidate Painter for BarSeries
        var barPainter = BarPainter(useGraphUnits: false);
        BarSeriesConfig? barConfig;

        // if (painters.getOrNull(i).runtimeType != BarPainter) {
        //   painters[i] = BarPainter(useGraphUnits: false);
        // } else {
        //   // Update if needed.
        // }

        for (var j = 0; j < barSeries.barData.length; j++) {
          final barGroup = barSeries.barData[j];

          // var config = cachedConfigs.getOrNull(barSeries);
          barConfig ??= BarSeriesConfig();
          // assert(barConfig is BarSeriesConfig);
          barConfig.updateEdges(barGroup, _updateMinMaxValues);
        }

        assert(barConfig != null);

        states.add(
          BarSeriesState(
            // currentData: currData.,
            targetData: barSeries,
            config: barConfig!,
            painter: barPainter,
          ),
        );
      });
    }

    // TODO: Invalidate the RangeData
    var results = _invalidateRangeValues();

    return CartesianData(state: states, range: results);
  }

  @override
  void aggregateData(List<CartesianSeries> data) {
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
          (config as BarSeriesConfig)
              .updateEdges(barGroup, _updateMinMaxValues);
        }
      });
    }
  }

  @override
  CartesianConfig? getConfig(CartesianSeries series) => cachedConfigs[series];

  @override
  Tween<CartesianData> getTweens({
    required CartesianData newData,
    required bool isInitPhase,
  }) =>
      CartesianDataTween(
        begin: isInitPhase ? CartesianData.zero(newData.range) : currData,
        end: newData,
      );

  @override
  void setAnimatableData(CartesianData data) => currData = data;

  @override
  CartesianData setData(List<CartesianSeries> data) {
    // aggregateData(data);
    // _invalidateRangeValues();
    targetData = data;
    _resetRangeData();
    return constructState(data);
  }

  _updateMinMaxValues(minX, maxX, minY, maxY) {
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
