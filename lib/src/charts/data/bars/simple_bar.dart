import 'package:equatable/equatable.dart';
import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';

/// Defines a Simple singular Bar with a Single Y-Value
///
/// See Also: [BarGroup]
class SimpleBar extends BarGroup with EquatableMixin {
  /// The Y-Value data ([BarData]) for this Bar.
  final BarData yValue;

  SimpleBar({
    required super.xValue,
    required this.yValue,
    super.label,
    super.labelStyle,
    super.groupStyle,
  });

  @override
  List<Object?> get props =>
      [super.xValue, yValue, super.label, super.labelStyle, super.groupStyle];
}
