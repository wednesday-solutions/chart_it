import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_group.dart';

class MultiBar extends BarGroup with EquatableMixin {
  final List<BarData> yValues;
  final BarGroupArrangement orientation;
  final double groupSpacing;

  MultiBar({
    required super.xValue,
    required this.yValues,
    // defaults to series i.e. side by side
    this.orientation = BarGroupArrangement.series,
    this.groupSpacing = 5.0,
    super.label,
    super.groupStyle,
  });

  @override
  List<Object?> get props => [xValue, yValues, label, groupStyle];
}
