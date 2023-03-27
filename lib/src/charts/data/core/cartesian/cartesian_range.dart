typedef CalculateCartesianRange = CartesianRangeResult Function(
  CartesianRangeContext context,
);

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
