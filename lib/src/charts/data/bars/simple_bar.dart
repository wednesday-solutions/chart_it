import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';

/// Defines a Simple singular Bar with a Single Y-Value
///
/// See Also: [BarGroup]
class SimpleBar extends BarGroup {
  /// The Y-Value data ([BarData]) for this Bar.
  final BarData yValue;

  /// Defines a Simple singular Bar with a Single Y-Value
  ///
  /// See Also: [BarGroup]
  SimpleBar({
    required super.xValue,
    required this.yValue,
    super.style,
    super.padding,
  });

  /// Lerps between two [SimpleBar]s for a factor [t]
  static SimpleBar lerp(BarGroup? current, BarGroup target, double t) {
    if ((current is SimpleBar?) && target is SimpleBar) {
      return SimpleBar(
        xValue: lerpDouble(current?.xValue, target.xValue, t) as num,
        yValue: BarData.lerp(current?.yValue, target.yValue, t),
        style: BarDataStyle.lerp(
          current?.style,
          target.style,
          t,
        ),
        padding: lerpDouble(current?.padding, target.padding, t) ?? 0.0,
      );
    } else {
      throw Exception('Both current & target data should be of same series!');
    }
  }

  @override
  List<Object?> get props => [xValue, yValue, style, padding];
}
