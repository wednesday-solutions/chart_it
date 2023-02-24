import 'package:flutter/material.dart';

class CartesianObserver extends ChangeNotifier {
  final double minValue;
  final double maxValue;
  final double xRange;
  final double yRange;
  int xUnitsCount;
  int yUnitsCount;

  // Values to keep updating when scrolling
  Offset? pointer;

  CartesianObserver({
    required this.minValue,
    required this.maxValue,
    required this.xRange,
    required this.yRange,
    this.xUnitsCount = 10,
    this.yUnitsCount = 10,
  });

  bool shouldRepaint(CartesianObserver changedValue) {
    if (maxValue != changedValue.maxValue ||
        minValue != changedValue.minValue ||
        xUnitsCount != changedValue.xUnitsCount ||
        yUnitsCount != changedValue.yUnitsCount ||
        pointer != changedValue.pointer) return true;

    return false;
  }
}
