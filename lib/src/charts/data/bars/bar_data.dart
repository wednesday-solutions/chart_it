import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data_style.dart';
import 'package:flutter_charts/src/charts/data/bars/multi_bar.dart';
import 'package:flutter_charts/src/charts/data/core/cartesian_data.dart';
import 'package:flutter_charts/src/charts/data/core/chart_text_style.dart';

/// Defines the Data of Each Individual Bar in a [MultiBar] group
///
/// Holds the Y-Value, label and styling for this BarData
class BarData extends Equatable {
  /// The LowerBound Value of Y-Axis. Only useful to control the Height
  /// of the drawn Bar in Stack Arrangement.
  final num? startYFrom;

  /// The UpperBound Value that's to be plotted along the Y-Axis.
  /// This will be drawn as the Height of the Bar
  final num yValue;

  /// Callback for the label along the Y-Axis in this [BarData]
  /// The Y-Value is provided as a param, and a string is to be returned
  final LabelMapper? label;

  /// Text Styling for the [label].
  final ChartTextStyle labelStyle;

  /// Styling for the Individual Bar in this [BarData].
  ///
  /// {@macro bar_styling_order}
  final BarDataStyle? barStyle;

  const BarData({
    this.startYFrom,
    required this.yValue,
    this.label,
    this.labelStyle = const ChartTextStyle(),
    this.barStyle,
  });

  @override
  List<Object?> get props => [startYFrom, yValue, label, labelStyle, barStyle];
}
