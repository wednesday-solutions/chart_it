import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_group.dart';

class MultiBar extends BarGroup with EquatableMixin {
  final List<BarData> yValues;
  final BarGroupArrangement arrangement;
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
