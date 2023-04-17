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
  /// The Current Data which will be lerped across every animation tick.
  late CartesianData currentData;

  /// The Target Data to which the chart needs to updates.
  List<CartesianSeries> targetData;

  /// Callback to calculate the X & Y ranges after Data Aggregation.
  final CalculateCartesianRange calculateRange;

  /// The maximum value along X-Axis.
  double _maxXValue = 0.0;

  /// The maximum value along Y-Axis.
  double _maxYValue = 0.0;

  /// The minimum value along X-Axis.
  double _minXValue = 0.0;

  /// The minimum value along Y-Axis.
  double _minYValue = 0.0;

  /// The maximum range across X-Axis.
  double maxXRange = 0.0;

  /// The maximum range across Y-Axis.
  double maxYRange = 0.0;

  /// The minimum range across X-Axis.
  double minXRange = 0.0;

  /// The minimum range across Y-Axis.
  double minYRange = 0.0;

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
      maxX: _maxXValue,
      maxY: _maxYValue,
      minX: _minXValue,
      minY: _minYValue,
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
          barConfig ??= BarSeriesConfig();
          barConfig.updateEdges(barGroup, _updateMinMaxValues);
        }

        assert(barConfig != null);

        states.add(
          BarSeriesState(
            data: barSeries,
            config: barConfig!,
            painter: barPainter,
          ),
        );
      });
    }

    // Invalidate the RangeData
    var results = _invalidateRangeValues();

    return CartesianData(state: states, range: results);
  }

  @override
  CartesianData setData(List<CartesianSeries> data) {
    targetData = data;
    _resetRangeData();
    return constructState(data);
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

  _updateMinMaxValues(minX, maxX, minY, maxY) {
    if (minX < _minXValue) {
      _minXValue = minX;
    }

    if (maxX > _maxXValue) {
      _maxXValue = maxX;
    }

    if (minY < _minYValue) {
      _minYValue = minY;
    }

    if (maxY > _maxYValue) {
      _maxYValue = maxY;
    }
  }

  _resetRangeData() {
    _maxXValue = 0.0;
    _maxYValue = 0.0;
    _minXValue = 0.0;
    _minYValue = 0.0;
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
