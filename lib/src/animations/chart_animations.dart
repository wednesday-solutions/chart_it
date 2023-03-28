import 'package:flutter/material.dart';

/// Handles updating [tweenSeries] with new data and manages the [animation].
///
/// To start listening to animation updates and update data along with notifying painters on each update
/// call [animateDataUpdates].
///
/// To update the tween when new data is available and animate to the new state call [updateDataSeries].
mixin ChartAnimationsMixin<T> on ChangeNotifier {
  @protected
  List<Tween<T>> get tweenSeries;

  set tweenSeries(List<Tween<T>> newTweens);

  AnimationController get animation;

  bool get animateOnLoad;

  bool get animateOnUpdate;

  void setData(List<T> data);

  void setAnimatableData(List<T> data);

  List<Tween<T>> getTweens({
    required List<T> newSeries,
    required bool isInitPhase,
  });

  /// **Should be called in the constructor of the class using [ChartAnimations].**
  ///
  /// Adds a listener on [animation].
  ///
  /// On every update calls :
  /// 1. [setAnimatableData] with the values of [tweenSeries] evaluated at current value of [animation].
  /// 2. [notifyListeners] so that [CustomPainter.paint] is called on the painters registered with this controller.
  void animateDataUpdates() {
    animation.addListener(() {
      setAnimatableData(
        tweenSeries.map((series) => series.evaluate(animation)).toList(),
      );
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
    tweenSeries = getTweens(newSeries: newSeries, isInitPhase: isInitPhase);
    // Update the Target Data to the newest value
    setData(newSeries);
    // Finally animate the differences
    final shouldAnimateOnLoad = isInitPhase && animateOnLoad;
    final shouldAnimateOnUpdate = !isInitPhase && animateOnUpdate;
    if (shouldAnimateOnLoad || shouldAnimateOnUpdate) {
      animation
        ..stop()
        ..reset()
        ..forward();
    } else {
      // We are to not animate the data updates
      setAnimatableData(newSeries);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    // We no longer need this animation controller
    animation.dispose();
  }
}
