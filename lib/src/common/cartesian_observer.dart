import 'package:flutter/material.dart';

class CartesianObserver<T> extends ChangeNotifier {
  final double minValue;
  final double maxValue;
  final double maxXRange;
  final double minXRange;
  final double maxYRange;
  final double minYRange;
  final AnimationController _animationController;
  final Tween<T> Function(T? oldData, T newData) tweenBuilder;
  Tween<T> tween;
  T? oldData;
  T data;
  T targetData;

  // Values to keep updating when scrolling
  Offset? pointer;

  CartesianObserver({
    required this.minValue,
    required this.maxValue,
    required this.maxXRange,
    this.minXRange = 0.0,
    required this.maxYRange,
    this.minYRange = 0.0,
    required AnimationController controller,
    required this.tweenBuilder,
    T targetData,
    required bool animateOnStart
  }) : _animationController = controller {
    tween = tweenBuilder(animateOnStart ? null : targetData, targetData);
    _animationController.addListener(() {
      // Get the current anim value
      data = tween.evaluate(_animationController);
      notifyListeners();
    });

    _animationController.forward();
  }

  void update(T newData) {
    targetData = newData;
    tween = tweenBuilder(oldData, targetData);
    _animationController.repeat();
    oldData = newData;
  }

  bool shouldRepaint(CartesianObserver changedValue) {
    if (maxValue != changedValue.maxValue ||
        minValue != changedValue.minValue ||
        minXRange != changedValue.minXRange ||
        maxXRange != changedValue.maxXRange ||
        minYRange != changedValue.minYRange ||
        maxYRange != changedValue.maxYRange ||
        pointer != changedValue.pointer) return true;

    return false;
  }
}
