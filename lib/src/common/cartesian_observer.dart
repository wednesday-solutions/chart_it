import 'package:flutter/material.dart';

class CartesianObserver extends ChangeNotifier {
  final double minValue;
  final double maxValue;
  final double maxXRange;
  final double minXRange;
  final double maxYRange;
  final double minYRange;

  int xUnitsCount;
  int yUnitsCount;

  // Values to keep updating when scrolling
  Offset? pointer;

  CartesianObserver({
    required this.minValue,
    required this.maxValue,
    required this.maxXRange,
    this.minXRange = 0.0,
    required this.maxYRange,
    this.minYRange = 0.0,
    this.xUnitsCount = 10,
    this.yUnitsCount = 10,
  });

  bool shouldRepaint(CartesianObserver changedValue) {
    if (maxValue != changedValue.maxValue ||
        minValue != changedValue.minValue ||
        minXRange != changedValue.minXRange ||
        maxXRange != changedValue.maxXRange ||
        minYRange != changedValue.minYRange ||
        maxYRange != changedValue.maxYRange ||
        xUnitsCount != changedValue.xUnitsCount ||
        yUnitsCount != changedValue.yUnitsCount ||
        pointer != changedValue.pointer) return true;

    return false;
  }
}
