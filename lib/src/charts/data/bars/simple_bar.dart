import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/core/chart_text_style.dart';
import 'package:equatable/equatable.dart';

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

  factory SimpleBar.zero() {
    return SimpleBar(
      xValue: 0,
      yValue: BarData.zero(),
    );
  }

  @override
  List<Object?> get props =>
      [super.xValue, yValue, super.label, super.labelStyle, super.groupStyle];

  @override
  SimpleBar lerp(BarGroup a, BarGroup b, double t) {
    if (a is SimpleBar && b is SimpleBar) {
      return SimpleBar(
        xValue: lerpDouble(a.xValue, b.xValue, t) as num,
        yValue: BarData.lerp(a.yValue, b.yValue, t),
        label: b.label,
        labelStyle: ChartTextStyle.lerp(a.labelStyle, b.labelStyle, t),
        groupStyle: BarDataStyle.lerp(a.groupStyle, b.groupStyle, t),
      );
    } else {
      throw Exception('Both current & target data should be of same series!');
    }
  }

  @override
  BarGroup get zeroValue => SimpleBar.zero();
}
