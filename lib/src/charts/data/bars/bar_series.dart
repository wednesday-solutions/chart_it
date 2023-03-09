import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data_style.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_group.dart';
import 'package:flutter_charts/src/charts/data/core/cartesian_data.dart';
import 'package:flutter_charts/src/charts/data/core/chart_text_style.dart';

class BarSeries extends CartesianSeries with EquatableMixin {
  final BarDataStyle? seriesStyle;
  final ChartTextStyle labelStyle;
  final List<BarGroup> barData;

  BarSeries({
    this.labelStyle = const ChartTextStyle(),
    this.seriesStyle,
    required this.barData,
  });

  @override
  List<Object?> get props => [labelStyle, seriesStyle, barData];
}
