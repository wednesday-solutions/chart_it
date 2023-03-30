import 'dart:ui';

import 'package:chart_it/src/animations/lerps.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:equatable/equatable.dart';

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
  final ChartTextStyle? labelStyle;

  /// Styling for the Individual Bar in this [BarData].
  ///
  /// {@macro bar_styling_order}
  final BarDataStyle? barStyle;

  /// Defines the Data of Each Individual Bar in a [MultiBar] group
  ///
  /// Holds the Y-Value, label and styling for this BarData
  const BarData({
    this.startYFrom,
    required this.yValue,
    this.label,
    this.labelStyle = const ChartTextStyle(),
    this.barStyle,
  });

  /// Lerps between two [BarData] values for a factor [t]
  static BarData lerp(BarData? current, BarData? target, double t) {
    return BarData(
      startYFrom: lerpDouble(current?.startYFrom, target?.startYFrom, t),
      yValue: lerpDouble(current?.yValue, target?.yValue, t) as num,
      label: target?.label,
      labelStyle: ChartTextStyle.lerp(
        current?.labelStyle,
        target?.labelStyle,
        t,
      ),
      barStyle: BarDataStyle.lerp(current?.barStyle, target?.barStyle, t),
    );
  }

  /// Lerps between two [BarData] Lists for a factor [t]
  static List<BarData> lerpBarDataList(
    List<BarData>? current,
    List<BarData> target,
    double t,
  ) =>
      lerpList(current, target, t, lerp: lerp);

  @override
  List<Object?> get props => [startYFrom, yValue, label, labelStyle, barStyle];
}
