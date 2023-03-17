import 'package:chart_it/src/animations/tweens.dart';
import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:flutter/material.dart';

class CartesianController extends ChangeNotifier {
  List<CartesianSeries> currentData = List.empty();
  List<CartesianSeries> data;

  // Animation Variables
  late List<Tween<CartesianSeries>> _tweenSeries;
  final AnimationController animation;
  final bool onLoadAnimate;

  final double minValue;
  final double maxValue;
  final double maxXRange;
  final double minXRange;
  final double maxYRange;
  final double minYRange;

  // Values to keep updating when scrolling
  Offset? pointer;

  CartesianController({
    required this.animation,
    this.onLoadAnimate = true,
    required this.data,
    required this.minValue,
    required this.maxValue,
    required this.maxXRange,
    this.minXRange = 0.0,
    required this.maxYRange,
    this.minYRange = 0.0,
  }) {
    animation.addListener(() {
      currentData =
          _tweenSeries.map((series) => series.evaluate(animation)).toList();

      // Finally trigger a rebuild for all the painters
      notifyListeners();
    });
    // On Initialization, we need to animate our chart if necessary
    updateDataSeries(data, isInitPhase: true);
  }

  void updateDataSeries(List<CartesianSeries> newSeries,
      {bool isInitPhase = false}) {
    // Tween a List of Tweens for CartesianSeries
    _tweenSeries = toCartesianTweens(
          isInitPhase ? List.empty() : currentData,
          newSeries,
        ) ??
        List.empty();
    // Update the Target Data to the newest value
    data = newSeries;
    // Finally animate the differences
    animation.forward();
  }

  bool shouldRepaint(CartesianController changedValue) {
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
