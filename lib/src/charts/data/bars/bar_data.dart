import 'dart:ui';

import 'package:chart_it/src/animations/lerps.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/chart_text_style.dart';
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

  factory BarData.zero() {
    return const BarData(
      yValue: 0,
    );
  }

  static BarData lerp(BarData? a, BarData? b, double t) {
    return BarData(
      startYFrom: lerpDouble(a?.startYFrom, b?.startYFrom, t),
      yValue: lerpDouble(a?.yValue, b?.yValue, t) as num,
      label: b?.label,
      labelStyle: ChartTextStyle.lerp(a?.labelStyle, b?.labelStyle, t),
      barStyle: BarDataStyle.lerp(a?.barStyle, b?.barStyle, t),
    );
  }

  static List<BarData> llerp(List<BarData>? a, List<BarData> b, double t) {
    return lerpList(a, b, t, lerp: lerp);
  }

  @override
  List<Object?> get props => [startYFrom, yValue, label, labelStyle, barStyle];
}
