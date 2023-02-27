import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data_style.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_group.dart';
import 'package:flutter_charts/src/charts/data/core/cartesian_data.dart';

class BarSeries extends CartesianSeries with EquatableMixin {
  final BarDataStyle? seriesStyle;
  final List<BarGroup> barData;

  BarSeries({
    this.seriesStyle,
    required this.barData,
  });

  @override
  List<Object?> get props => [seriesStyle, barData];
}
