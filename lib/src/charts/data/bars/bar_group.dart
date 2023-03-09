import 'package:flutter_charts/src/charts/data/bars/bar_data.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data_style.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_series.dart';
import 'package:flutter_charts/src/charts/data/core/cartesian_data.dart';
import 'package:flutter_charts/src/charts/data/core/chart_text_style.dart';
import 'package:flutter_charts/src/charts/widgets/bar_chart.dart';

/// Sets the Arrangement for all the bars in a [BarGroup].
///
/// * Use [series] to have all the bars arranged alongside each other.
/// * Use [stack] to create a stack of all the bars in a group.
enum BarGroupArrangement { series, stack }

/// {@template bar_group}
/// Defines the structure of a Group of Bars
///
/// Holds the X-Value, Labels and Styling for the inheriting class
/// {@endtemplate}
abstract class BarGroup {
  /// The Value along X-Axis for this [BarGroup].
  /// Note that this value isn't considered in plotting on X-Axis
  /// for [BarChart] widget.
  final num xValue;

  /// Callback for the label underneath a [BarGroup].
  /// The X-Value is provided as a param, and a string is to be returned
  final LabelMapper? label;

  /// Text Styling for the [label].
  final ChartTextStyle? labelStyle;

  /// Styling for the Bars in this [BarGroup].
  ///
  /// * Providing styling here will override the defined seriesStyle in [BarSeries].
  /// * Sets uniform styling for all the bars in the group,
  /// unless overridden by barStyle in individual [BarData].
  final BarDataStyle? groupStyle;

  BarGroup({
    required this.xValue,
    this.label,
    this.labelStyle,
    this.groupStyle,
  });
}
