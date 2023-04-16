import 'dart:math';

import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/bars/bar_interactions.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:chart_it/src/charts/widgets/bar_chart.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';

/// This class defines the Data Set to be provided to the BarChart
/// and the Global Styling options.
///
/// The BarSeries is **mandatory** to be provided to the [BarChart] widget.
///
/// See Also: [CartesianSeries]
class BarSeries extends CartesianSeries<BarInteractionResult>
    with EquatableMixin {
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

  /// This class defines the Data Set to be provided to the BarChart,
  /// the Global Styling options and any interaction events that could be
  /// performed on the following Data.
  ///
  /// The BarSeries is **mandatory** to be provided to the [BarChart] widget.
  ///
  /// See Also: [CartesianSeries]
  BarSeries({
    this.labelStyle = defaultChartTextStyle,
    this.seriesStyle,
    required this.barData,
    super.interactionEvents = const BarInteractionEvents(isEnabled: false),
  });

  /// Constructs a Factory Instance of [BarSeries] without any Data.
  factory BarSeries.zero() => BarSeries(barData: List.empty());

  @override
  List<Object?> get props => [
        labelStyle,
        seriesStyle,
        barData,
        super.interactionEvents,
      ];

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
      interactionEvents: target.interactionEvents,
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
