import 'package:chart_it/src/animations/chart_data_animation_controller_mixin.dart';
import 'package:chart_it/src/animations/tweens.dart';
import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:flutter/material.dart';

class CartesianController extends ChangeNotifier
    with ChartDataAnimationControllerMixin<CartesianSeries> {
  List<CartesianSeries> currentData = List.empty();
  List<CartesianSeries> data;

  // Animation Variables
  @override
  late List<Tween<CartesianSeries>> tweenSeries;
  @override
  final AnimationController animation;
  @override
  final bool animateOnLoad;
  @override
  final bool animateOnUpdate;

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
    this.animateOnLoad = true,
    this.animateOnUpdate = true,
    required this.data,
    required this.minValue,
    required this.maxValue,
    required this.maxXRange,
    this.minXRange = 0.0,
    required this.maxYRange,
    this.minYRange = 0.0,
  }) {
    listenAnimationValueAndUpdate();
    // On Initialization, we need to animate our chart if necessary
    updateDataSeries(data, isInitPhase: true);
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

  @override
  List<Tween<CartesianSeries>> generateTween({
    required List<CartesianSeries> newSeries,
    required bool isInitPhase,
  }) {
    return toCartesianTweens(
          isInitPhase ? List.empty() : currentData,
          newSeries,
        ) ??
        List.empty();
  }

  @override
  void setCurrentData(List<CartesianSeries> data) => currentData = data;

  @override
  void setData(List<CartesianSeries> data) => this.data = data;
}
