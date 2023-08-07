import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Defines a Callback that returns a [CartesianRangeResult] for the
/// provided [context] of type [CartesianRangeContext].
typedef CalculateCartesianRange = CartesianRangeResult Function(
  CartesianRangeContext context,
);

/// Wraps the Minimum & Maximum values for X & Y values in a Cartesian Chart
class CartesianRangeContext with EquatableMixin {
  double maxX;
  double maxY;
  double minX;
  double minY;

  CartesianRangeContext(this.maxX, this.maxY, this.minX, this.minY);

  @override
  List<Object?> get props => [maxX, minX, maxY, minY];
}

/// A Result Wrapper that provides the X & Y Ranges and the unit values.
class CartesianRangeResult with EquatableMixin {
  double xUnitValue;
  double yUnitValue;

  double maxXRange;
  double maxYRange;
  double minXRange;
  double minYRange;

  CartesianRangeResult({
    required this.xUnitValue,
    required this.yUnitValue,
    required this.maxXRange,
    required this.maxYRange,
    required this.minXRange,
    required this.minYRange,
  });

  static CartesianRangeResult lerp(
    CartesianRangeResult? current,
    CartesianRangeResult target,
    double t,
  ) {
    return CartesianRangeResult(
      xUnitValue: lerpDouble(current?.xUnitValue, target.xUnitValue, t) ?? 1,
      yUnitValue: lerpDouble(current?.yUnitValue, target.yUnitValue, t) ?? 1,
      maxXRange: lerpDouble(current?.maxXRange, target.maxXRange, t) ?? 0,
      maxYRange: lerpDouble(current?.maxYRange, target.maxYRange, t) ?? 0,
      minXRange: lerpDouble(current?.minXRange, target.minXRange, t) ?? 0,
      minYRange: lerpDouble(current?.minYRange, target.minYRange, t) ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        xUnitValue,
        yUnitValue,
        maxXRange,
        maxYRange,
        minXRange,
        minYRange,
      ];
}
