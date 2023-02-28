import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_group.dart';

class SimpleBar extends BarGroup with EquatableMixin {
  final BarData yValue;

  SimpleBar({
    required super.xValue,
    required this.yValue,
    super.label,
    super.groupStyle,
  });

  @override
  List<Object?> get props =>
      [super.xValue, yValue, super.label, super.groupStyle];
}
