import 'dart:math';

import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:chart_it/src/charts/widgets/bar_chart.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
import 'package:chart_it/src/interactions/config/bar_interaction_config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';

/// This class defines the Data Set to be provided to the BarChart
/// and the Global Styling options
///
/// The BarSeries is **mandatory** to be provided to the [BarChart] widget.
///
/// See Also: [CartesianSeries]
class BarSeries extends CartesianSeries with EquatableMixin {
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

  final BarInteractionConfig interactionConfig;

  BarSeries({
    this.labelStyle = const ChartTextStyle(),
    this.seriesStyle,
    required this.barData,
    this.interactionConfig = const BarInteractionConfig(isEnabled: false),
  });

  factory BarSeries.zero() {
    return BarSeries(
      barData: List.empty(),
    );
  }

  @override
  List<Object?> get props => [labelStyle, seriesStyle, barData];

  static BarSeries lerp(
    CartesianSeries? current,
    CartesianSeries target,
    double t,
  ) {
    if ((current is BarSeries?) && target is BarSeries) {
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
      );
    } else {
      throw Exception('Both current & target data should be of same series!');
    }
  }
}

class BarSeriesConfig extends CartesianConfig {
  var maxBarsInGroup = 1;
  var calculatedMinXValue = 0.0;
  var calculatedMaxXValue = double.infinity;
  var calculatedMinYValue = 0.0;
  var calculatedMaxYValue = double.infinity;

  BarSeriesConfig();

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
      for (final data in yValue) {
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

class BarSeriesTween extends Tween<BarSeries> {
  BarSeriesTween({
    required BarSeries? begin,
    required BarSeries end,
  }) : super(begin: begin, end: end);

  @override
  BarSeries lerp(double t) => BarSeries.lerp(begin, end!, t);
}
