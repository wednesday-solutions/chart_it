import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:equatable/equatable.dart';

/// Defines a Simple singular Bar with a Single Y-Value
///
/// See Also: [BarGroup]
class SimpleBar extends BarGroup with EquatableMixin {
  /// The Y-Value data ([BarData]) for this Bar.
  final BarData yValue;

  /// Defines a Simple singular Bar with a Single Y-Value
  ///
  /// See Also: [BarGroup]
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

  /// Lerps between two [SimpleBar]s for a factor [t]
  static SimpleBar lerp(BarGroup? current, BarGroup target, double t) {
    if ((current is SimpleBar?) && target is SimpleBar) {
      return SimpleBar(
        xValue: lerpDouble(current?.xValue, target.xValue, t) as num,
        yValue: BarData.lerp(current?.yValue, target.yValue, t),
        label: target.label,
        labelStyle:
            ChartTextStyle.lerp(current?.labelStyle, target.labelStyle, t),
        groupStyle:
            BarDataStyle.lerp(current?.groupStyle, target.groupStyle, t),
      );
    } else {
      throw Exception('Both current & target data should be of same series!');
    }
  }
}
