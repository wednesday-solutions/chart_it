import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_group.dart';

/// Defines a Group of Multiple Bars
///
/// A list of [BarData] needs to be provided which will
/// provide us the Y-Value for each individual bar in the group.
///
/// See Also: [BarGroup]
class MultiBar extends BarGroup with EquatableMixin {
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
  /// will throw an Assertion.
  final double groupSpacing;

  MultiBar({
    required super.xValue,
    required this.yValues,
    // defaults to series i.e. side by side
    this.arrangement = BarGroupArrangement.series,
    this.groupSpacing = 0.0,
    super.label,
    super.labelStyle,
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

  @override
  List<Object?> get props => [xValue, yValues, label, labelStyle, groupStyle];
}
