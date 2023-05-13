import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_data_style.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/extensions/primitives.dart';

/// Defines a Group of Multiple Bars
///
/// A list of [BarData] needs to be provided which will
/// provide us the Y-Value for each individual bar in the group.
///
/// See Also: [BarGroup]
class MultiBar extends BarGroup {
  /// The list of [BarData] which gives us the Y-Value and
  /// the styling for each individual bars in this group.
  final List<BarData> yValues;

  /// Defines how all the bars in this group should be arranged
  /// * Use [BarGroupArrangement.series] to arrange in series
  /// * Use [BarGroupArrangement.stack] to arrange in stack
  final BarGroupArrangement arrangement;

  /// The space between consecutive bars in a series arrangement.
  ///
  /// **Note:** If you've chosen [arrangement] as stack, then do not use
  /// groupSpacing. Providing a value higher than zero in the case
  /// will throw an Exception.
  final double groupSpacing;

  /// Defines a Group of Multiple Bars
  ///
  /// A list of [BarData] needs to be provided which will
  /// provide us the Y-Value for each individual bar in the group.
  ///
  /// See Also: [BarGroup]
  ///
  MultiBar({
    required super.xValue,
    required this.yValues,
    // defaults to series i.e. side by side
    this.arrangement = BarGroupArrangement.series,
    this.groupSpacing = 0.0,
    super.groupStyle,
  })  : assert(yValues.isNotEmpty, "At least one yValue is required!"),
        // Ensure that groupSpacing is not applied when arrangement is stack
        assert(
          (arrangement == BarGroupArrangement.stack && groupSpacing > 0.0)
              ? false
              : true,
          "groupSpacing should not be used when Bar Arrangement is Stack!",
        ),
        assert(groupSpacing >= 0.0, "groupSpacing cannot be Negative!");

  /// Lerps between two [MultiBar]s for a factor [t]
  static MultiBar lerp(BarGroup? current, BarGroup target, double t) {
    if ((current is MultiBar?) && target is MultiBar) {
      return MultiBar(
        xValue: lerpDouble(current?.xValue, target.xValue, t) as num,
        yValues: BarData.lerpBarDataList(current?.yValues, target.yValues, t),
        arrangement: target.arrangement,
        groupSpacing: lerpDouble(
          current?.groupSpacing,
          target.groupSpacing,
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
  List<Object?> get props =>
      [xValue, yValues, groupStyle, groupSpacing, arrangement];
}
