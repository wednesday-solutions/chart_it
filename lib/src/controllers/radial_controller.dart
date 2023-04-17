import 'package:chart_it/src/animations/chart_animations.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';
import 'package:chart_it/src/charts/data/pie/pie_series.dart';
import 'package:chart_it/src/charts/painters/radial/pie_painter.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/charts/state/pie_series_state.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/material.dart';

/// The Animation and Data Controller for a Radial Chart.
///
/// Encapsulates the required Chart Data, Animatable Data, Configs
/// and Mapped Painters for every [RadialSeries].
class RadialController extends ChangeNotifier
    with
        // RadialDataMixin,
        ChartAnimationsMixin<RadialData, RadialSeries>,
        InteractionDispatcher {
  /// The Current Data which will be lerped across every animation tick.
  late RadialData currentData;

  /// The Target Data to which the chart needs to updates.
  List<RadialSeries> targetData;

  /// The minimum value across all Series.
  double minValue = 0.0;

  /// The maximum value across all Series.
  double maxValue = 0.0;

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
    required this.targetData,
    required this.animation,
    this.animateOnUpdate = true,
    this.animateOnLoad = true,
  }) {
    animateDataUpdates();
    // // On Initialization, we need to animate our chart if necessary
    updateDataSeries(targetData, isInitPhase: true);
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
      animateDataUpdates();
    }

    if (targetData != null && this.targetData != targetData) {
      updateDataSeries(targetData, isInitPhase: false);
    }
  }

  @override
  RadialData constructState(List<RadialSeries> newData) {
    // TODO: New Data is our target data.
    var states = <PaintingState>[];

    for (var i = 0; i < newData.length; i++) {
      final series = newData[i];
      series.when(onPieSeries: (pieSeries) {
        // Invalidate Painter for PieSeries
        var piePainter = PiePainter();
        PieSeriesConfig? pieConfig;

        // if (painters.getOrNull(i).runtimeType != BarPainter) {
        //   painters[i] = BarPainter(useGraphUnits: false);
        // } else {
        //   // Update if needed.
        // }

        for (var j = 0; j < pieSeries.slices.length; j++) {
          final slice = pieSeries.slices[j];
          pieConfig ??= PieSeriesConfig();
          pieConfig.updateEdges(slice, _updateMinMaxValues);
        }

        assert(pieConfig != null);

        states.add(
          PieSeriesState(
            data: pieSeries,
            config: pieConfig!,
            painter: piePainter,
          ),
        );
      });
    }

    // We cannot show Negative Values in Radial Charts, so for now
    // We will throw exception if either of min or max values are negative
    // FIXME: SUBJECT TO CHANGE
    if (minValue.isNegative || maxValue.isNegative) {
      throw ArgumentError('Radial Charts cannot display Negative Values!');
    }

    return RadialData(state: states);
  }

  @override
  RadialData setData(List<RadialSeries> data) {
    targetData = data;
    _resetRangeData();
    return constructState(data);
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
