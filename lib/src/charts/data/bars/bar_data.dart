import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data_style.dart';
import 'package:flutter_charts/src/charts/data/core/cartesian_data.dart';
import 'package:flutter_charts/src/charts/data/core/chart_text_style.dart';

class BarData extends Equatable {
  final num? startYFrom;
  final num yValue;
  final LabelMapper? label;
  final ChartTextStyle labelStyle;
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
