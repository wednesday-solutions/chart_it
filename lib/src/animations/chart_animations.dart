import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/material.dart';

/// Handles updating [tweenSeries] with new data and manages the [animation].
///
/// To start listening to animation updates and update data along with notifying painters on each update
/// call [animateDataUpdates].
///
/// To update the tween when new data is available and animate to the new state call [updateDataSeries].
mixin ChartAnimationsMixin<T, M> on ChangeNotifier {
  @protected
  late List<Tween<T>> tweenSeries;
  late Tween<M> minMaxTween;

  AnimationController get animation;

  bool get animateOnLoad;

  bool get animateOnUpdate;

  M setData(List<T> data);

  void setAnimatableData(List<T> data, M minMax);

  List<Tween<T>> getSeriesTweens({
    required List<T> newSeries,
    required bool isInitPhase,
  });

  Tween<M> getMinMaxTween(M minMaxData, bool isInitPhase);

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
        tweenSeries.fastMap((series) => series.evaluate(animation)),
        minMaxTween.evaluate(animation)
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
  @protected
  void updateDataSeries(
    List<T> newSeries, {
    bool isInitPhase = false,
  }) {
    // Tween a List of Tweens for CartesianSeries
    tweenSeries = getSeriesTweens(newSeries: newSeries, isInitPhase: isInitPhase);
    // Update the Target Data to the newest value
    final minMaxData = setData(newSeries);
    minMaxTween = getMinMaxTween(minMaxData, isInitPhase);
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
      setAnimatableData(newSeries, minMaxData);
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
