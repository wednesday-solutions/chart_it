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

/// This class defines the Data Set to be provided to the BarChart
/// and the Global Styling options.
///
/// The BarSeries is **mandatory** to be provided to the [BarChart] widget.
///
/// See Also: [CartesianSeries]
class BarSeries extends CartesianSeries<BarInteractionEvents>
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

  /// Updates the Minimum & Maximum X & Y values for this series config.
  /// Returns the newly calculated minimum's and maximums in [onUpdate].
  void calcBarDataRange(
    List<BarGroup> barData,
    Function(double minX, double maxX, double minY, double maxY) onUpdate,
  ) {
    for (var i = 0; i < barData.length; i++) {
      final barGroup = barData[i];
      var yValue = barGroup.yValues();

      var minX = 0.0;
      var maxX = double.infinity;

      var minY = double.infinity;
      var maxY = 0.0;

      if (barGroup is MultiBar &&
          barGroup.arrangement == BarGroupArrangement.stack) {
        // In a Vertical Stack, we can also have few bars in Negative Region
        minY = min(minY, yValue.fold(0, (a, b) => min(a, b.yValue.toDouble())));
        // For a stack, the y value of the bar is the total of all bars
        maxY = max(maxY, yValue.fold(0, (a, b) => a + b.yValue));
      } else {
        for (var i = 0; i < yValue.length; i++) {
          final data = yValue[i];
          minY = min(minY, data.yValue.toDouble());
          maxY = max(maxY, data.yValue.toDouble());
        }
      }

      minX = min(minX, barGroup.xValue.toDouble());
      maxX = max(maxX, barGroup.xValue.toDouble());

      maxBarsInGroup = max(maxBarsInGroup, yValue.length);

      onUpdate(minX, maxX, minY, maxY);
    }
  }
}
