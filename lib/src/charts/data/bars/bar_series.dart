import 'dart:math';

import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:chart_it/src/charts/widgets/bar_chart.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';

/// This class defines the Data Set to be provided to the BarChart
/// and the Global Styling options.
///
/// The BarSeries is **mandatory** to be provided to the [BarChart] widget.
///
/// See Also: [CartesianSeries]
class BarSeries extends CartesianSeries<BarChartInteractionResult> with EquatableMixin {
  /// Sets uniform styling for All the Bars in this [BarSeries].
  ///
  /// {@macro bar_styling_order}
  final BarDataStyle? seriesStyle;

  /// Sets uniform styling for All the Group Labels in this [BarSeries].
  ///
  /// This styling can be overridden by:
  /// * labelStyle in any [BarGroup]
  final ChartTextStyle? labelStyle;

  /// The DataSet for our BarChart. It is Structured as a [BarGroup]
  /// that provides the X-Value and can contain a
  /// single or multiple group of bars.
  final List<BarGroup> barData;

  /// This class defines the Data Set to be provided to the BarChart
  /// and the Global Styling options.
  ///
  /// The BarSeries is **mandatory** to be provided to the [BarChart] widget.
  ///
  /// See Also: [CartesianSeries]
  BarSeries({
    this.labelStyle = const ChartTextStyle(),
    this.seriesStyle,
    required this.barData,
    super.interactionConfig = const BarInteractionConfig(isEnabled: false),
  });

  /// Constructs a Factory Instance of [BarSeries] without any Data.
  factory BarSeries.zero() => BarSeries(barData: List.empty());

  @override
  List<Object?> get props => [labelStyle, seriesStyle, barData];

  /// Lerps between two [BarSeries] for a factor [t]
  static BarSeries lerp(
    BarSeries? current,
    BarSeries target,
    double t,
  ) {
    return BarSeries(
      labelStyle: ChartTextStyle.lerp(
        current?.labelStyle,
        target.labelStyle,
        t,
      ),
      seriesStyle: BarDataStyle.lerp(
        current?.seriesStyle,
        target.seriesStyle,
        t,
      ),
      barData: BarGroup.lerpBarGroupList(current?.barData, target.barData, t),
      interactionConfig: target.interactionConfig,
    );
  }
}

/// Defines [BarSeries] specific data variables, which are utilized
/// when drawing a [BarChart].
///
/// Also calculates the minimum & maximum value in a given [BarGroup].
class BarSeriesConfig extends CartesianConfig {
  /// Highest Count for number of bars in BarGroup
  var maxBarsInGroup = 1;

  /// Calculated Minimum for X-Value
  var calculatedMinXValue = 0.0;

  /// Calculated Maximum for X-Value
  var calculatedMaxXValue = 0.0;

  /// Calculated Minimum for Y-Value
  var calculatedMinYValue = 0.0;

  /// Calculated Maximum for Y-Value
  var calculatedMaxYValue = 0.0;

  /// Updates the Minimum & Maximum X & Y values for this series config.
  /// Returns the newly calculated minimum's and maximums in [onUpdate].
  void updateEdges(
    BarGroup group,
    Function(double minX, double maxX, double minY, double maxY) onUpdate,
  ) {
    var yValue = group.yValues();

    var minV = double.infinity;
    var maxV = 0.0;

    if (group is MultiBar && group.arrangement == BarGroupArrangement.stack) {
      minV = min(minV, 0);
      // For a stack, the y value of the bar is the total of all bars
      maxV = max(maxV, yValue.fold(0, (a, b) => a + b.yValue));
    } else {
      for (var i = 0; i < yValue.length; i++) {
        final data = yValue[i];
        minV = min(minV, data.yValue.toDouble());
        maxV = max(maxV, data.yValue.toDouble());
      }
    }

    calculatedMinYValue = min(calculatedMinYValue, minV);
    calculatedMaxYValue = max(calculatedMaxYValue, maxV);
    maxBarsInGroup = max(maxBarsInGroup, yValue.length);

    onUpdate(
      calculatedMinXValue,
      calculatedMaxXValue,
      calculatedMinYValue,
      calculatedMaxYValue,
    );
  }
}

/// A Tween to interpolate between two [BarSeries]
///
/// [end] object must not be null.
class BarSeriesTween extends Tween<BarSeries> {
  /// A Tween to interpolate between two [BarSeries]
  ///
  /// [end] object must not be null.
  BarSeriesTween({
    required BarSeries? begin,
    required BarSeries end,
  }) : super(begin: begin, end: end);

  @override
  BarSeries lerp(double t) => BarSeries.lerp(begin, end!, t);
}

abstract class ChartInteractionConfig<T extends ChartInteractionResult> {
  final bool isEnabled;
  final void Function(T interactionResult)? onRawInteraction;
  final void Function(T interactionResult)? onTap;
  final void Function(T interactionResult)? onDoubleTap;
  final void Function(T interactionResult)? onDragStart;
  final void Function(T interactionResult)? onDrag;
  final void Function(T interactionResult)? onDragEnd;

  const ChartInteractionConfig({
    this.onRawInteraction,
    required this.onTap,
    required this.onDoubleTap,
    required this.onDragStart,
    required this.onDrag,
    required this.onDragEnd,
    required this.isEnabled,
  });

  void onInteraction(T interactionResult) {
    switch (interactionResult.interactionType) {
      case ChartInteractionType.tap:
        onTap?.call(interactionResult);
        break;
      case ChartInteractionType.doubleTap:
        onDoubleTap?.call(interactionResult);
        break;
      case ChartInteractionType.drag:
        onDragStart?.call(interactionResult);
        break;
      case ChartInteractionType.dragStart:
        onDrag?.call(interactionResult);
        break;
      case ChartInteractionType.dragEnd:
        onDragEnd?.call(interactionResult);
        break;
    }
  }

  bool get shouldHitTest =>
      isEnabled &&
      (onRawInteraction != null ||
          onTap != null ||
          onDoubleTap != null ||
          onDragStart != null ||
          onDragEnd != null ||
          onDrag != null);
}

class BarInteractionConfig extends ChartInteractionConfig<BarChartInteractionResult> {
  const BarInteractionConfig({
    required super.isEnabled,
    super.onTap,
    super.onDoubleTap,
    super.onRawInteraction,
    super.onDragStart,
    super.onDrag,
    super.onDragEnd,
  });
}

abstract class ChartInteractionBehaviour {}

class CrossHairOnDrag extends ChartInteractionBehaviour {

}
