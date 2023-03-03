import 'package:flutter/material.dart';

class CartesianObserver extends ChangeNotifier {
  final double minValue;
  final double maxValue;
  final double maxXRange;
  final double minXRange;
  final double maxYRange;
  final double minYRange;

  final double xUnitValue;
  final double yUnitValue;

  // Values to keep updating when scrolling
  Offset? pointer;

  CartesianObserver({
    required this.minValue,
    required this.maxValue,
    required this.xUnitValue,
    required this.yUnitValue,
    required this.maxXRange,
    this.minXRange = 0.0,
    required this.maxYRange,
    this.minYRange = 0.0,
  });

  bool shouldRepaint(CartesianObserver changedValue) {
    if (maxValue != changedValue.maxValue ||
        minValue != changedValue.minValue ||
        minXRange != changedValue.minXRange ||
        maxXRange != changedValue.maxXRange ||
        minYRange != changedValue.minYRange ||
        maxYRange != changedValue.maxYRange ||
        xUnitValue != changedValue.xUnitValue ||
        yUnitValue != changedValue.yUnitValue ||
        pointer != changedValue.pointer) return true;

    return false;
  }
}
