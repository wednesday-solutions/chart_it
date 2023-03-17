import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:flutter/animation.dart';

typedef TweenBuilder<T> = Tween<T> Function(T? current, T target);

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
  return _buildTweens(current, target, builder: (a, b) {
    switch (a.runtimeType) {
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
  if (current != null) {
    return List.generate(
      target.length,
      (i) => builder(i >= current.length ? target[i] : current[i], target[i]),
    );
  } else {
    return target.map((data) => builder(data, data)).toList();
  }
}
