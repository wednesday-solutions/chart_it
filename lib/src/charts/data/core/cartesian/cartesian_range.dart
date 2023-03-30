/// Defines a Callback that returns a [CartesianRangeResult] for the
/// provided [context] of type [CartesianRangeContext].
typedef CalculateCartesianRange = CartesianRangeResult Function(
  CartesianRangeContext context,
);

/// Wraps the Minimum & Maximum values for X & Y values in a Cartesian Chart
class CartesianRangeContext {
  double maxX;
  double maxY;
  double minX;
  double minY;

  CartesianRangeContext({
    required this.maxX,
    required this.maxY,
    required this.minX,
    required this.minY,
  });
}

/// A Result Wrapper that provides the X & Y Ranges and the unit values.
class CartesianRangeResult {
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
}
