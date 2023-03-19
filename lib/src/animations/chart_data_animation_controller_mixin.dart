import 'package:flutter/material.dart';

/// Handles updating [tweenSeries] with new data and manages the [animation].
///
/// To start listening to animation updates and update data along with notifying painters on each update
/// call [listenAnimationValueAndUpdate].
///
/// To update the tween when new data is available and animate to the new state call [updateDataSeries].
mixin ChartDataAnimationControllerMixin<T> on ChangeNotifier {
  @protected
  List<Tween<T>> get tweenSeries;

  set tweenSeries(List<Tween<T>> newTweenList);

  AnimationController get animation;

  bool get animateOnLoad;

  bool get animateOnUpdate;

  void setData(List<T> data);

  void setCurrentData(List<T> data);

  List<Tween<T>> generateTween(
      {required List<T> newSeries, required bool isInitPhase});

  /// **Should be called in the constructor of the class using [ChartDataAnimationControllerMixin].**
  ///
  /// Adds a listener on [animation].
  ///
  /// On every update calls :
  /// 1. [setCurrentData] with the values of [tweenSeries] evaluated at current value of [animation].
  /// 2. [notifyListeners] so that [CustomPainter.paint] is called on the painters registered with this controller.
  void listenAnimationValueAndUpdate() {
    animation.addListener(() {
      setCurrentData(
          tweenSeries.map((series) => series.evaluate(animation)).toList());
      // Finally trigger a rebuild for all the painters
      notifyListeners();
    });
  }

  /// Call to update the controller with new/updated chart data and start the [animation] if applicable.
  ///
  /// [updateDataSeries] does the following:
  /// 1. Updates the [tweenSeries] with tween created from the [newSeries] data.
  /// 2. [setData] with the [newSeries].
  /// 3. Starts the [animation] if applicable.
  void updateDataSeries(
    List<T> newSeries, {
    bool isInitPhase = false,
  }) {
    // Tween a List of Tweens for CartesianSeries
    tweenSeries = generateTween(newSeries: newSeries, isInitPhase: isInitPhase);
    // Update the Target Data to the newest value
    setData(newSeries);
    // Finally animate the differences
    final shouldAnimateOnLoad = isInitPhase && animateOnLoad;
    final shouldAnimateOnUpdate = !isInitPhase && animateOnUpdate;
    if (shouldAnimateOnLoad || shouldAnimateOnUpdate) {
      // TODO: Check if animation.forward works if the animation is already in completed state which can happen for update animations.
      animation.forward();
    }
  }
}
