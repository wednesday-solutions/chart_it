import 'package:flutter/material.dart';

class RadialController extends ChangeNotifier {
  final double minValue;
  final double maxValue;

  // Values to keep updating when scrolling
  Offset? pointer;

  RadialController({
    required this.minValue,
    required this.maxValue,
  });

  bool shouldRepaint(RadialController changedValue) {
    if (maxValue != changedValue.maxValue ||
        minValue != changedValue.minValue ||
        pointer != changedValue.pointer) return true;

    return false;
  }
}
