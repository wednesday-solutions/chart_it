import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/extensions/primitives.dart';

/// Defines a Simple singular Bar with a Single Y-Value
///
/// See Also: [BarGroup]
class SimpleBar extends BarGroup {
  /// The Y-Value data ([BarData]) for this Bar.
  final BarData yValue;

  /// The space between consecutive bars.
  final double barSpacing;

  /// Defines a Simple singular Bar with a Single Y-Value
  ///
  /// See Also: [BarGroup]
  SimpleBar({
    required super.xValue,
    required this.yValue,
    this.barSpacing = 5.0,
    super.groupStyle,
  });

  /// Lerps between two [SimpleBar]s for a factor [t]
  static SimpleBar lerp(BarGroup? current, BarGroup target, double t) {
    if ((current is SimpleBar?) && target is SimpleBar) {
      return SimpleBar(
        xValue: lerpDouble(current?.xValue, target.xValue, t) as num,
        yValue: BarData.lerp(current?.yValue, target.yValue, t),
        barSpacing: lerpDouble(
          current?.barSpacing,
          target.barSpacing,
          t,
        ).asOrDefault(0.0),
        groupStyle: BarDataStyle.lerp(
          current?.groupStyle,
          target.groupStyle,
          t,
        ),
      );
    } else {
      throw Exception('Both current & target data should be of same series!');
    }
  }

  @override
  List<Object?> get props => [xValue, yValue, groupStyle];
}
