import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:flutter/animation.dart';

typedef TweenBuilder<T> = Tween<T> Function(Type type, T? current, T target);

class BarSeriesTween extends Tween<BarSeries> {
  BarSeriesTween({
    required BarSeries begin,
    required BarSeries end,
  }) : super(begin: begin, end: end);

  @override
  BarSeries lerp(double t) => begin!.lerp(begin!, end!, t);
}

List<Tween<CartesianSeries>>? toCartesianTweens(
  List<CartesianSeries> current,
  List<CartesianSeries> target,
) {
  return _buildTweens(current, target, builder: (type, a, b) {
    switch (type) {
      case BarSeries:
        return BarSeriesTween(begin: a as BarSeries, end: b as BarSeries);
      default:
        throw TypeError();
    }
  });
}

List<Tween<T>>? _buildTweens<T>(
  List<T>? current,
  List<T> target, {
  required TweenBuilder<T> builder,
}) {
  if (current != null && current.length == target.length) {
    return List.generate(
        current.length, (i) => builder(T.runtimeType, current[i], target[i]));
  } else if (current != null) {
    return List.generate(
      target.length,
      (i) => builder(
        T.runtimeType,
        i >= current.length ? target[i] : current[i],
        target[i],
      ),
    );
  } else {
    return target.map((data) => builder(T.runtimeType, data, data)).toList();
  }
}
