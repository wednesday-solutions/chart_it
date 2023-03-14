import 'package:flutter/material.dart';

class RadialObserver extends ChangeNotifier {
  final double minValue;
  final double maxValue;

  // Values to keep updating when scrolling
  Offset? pointer;

  RadialObserver({
    required this.minValue,
    required this.maxValue,
  });

  bool shouldRepaint(RadialObserver changedValue) {
    final c = AnimationController();
    Tween().animate(c);
    if (maxValue != changedValue.maxValue ||
        minValue != changedValue.minValue ||
        pointer != changedValue.pointer) return true;

    return false;
  }
}
