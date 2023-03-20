import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:flutter/animation.dart';
import 'package:chart_it/src/extensions/primitives.dart';

typedef TweenBuilder<T> = Tween<T> Function(T? current, T target);

class BarSeriesTween extends Tween<BarSeries> {
  BarSeriesTween({
    required BarSeries? begin,
    required BarSeries end,
  }) : super(begin: begin, end: end);

  @override
  BarSeries lerp(double t) => BarSeries.lerp(begin, end!, t);
}

List<Tween<CartesianSeries>>? toCartesianTweens(
  List<CartesianSeries>? current,
  List<CartesianSeries> target,
) {
  return _buildTweens(current, target, builder: (current, target) {
    final currentValue =
        current == null || current.runtimeType != target.runtimeType
            ? BarSeries.zero()
            : current;
    return target.when(
      barSeries: () => BarSeriesTween(
          begin: currentValue as BarSeries, end: target as BarSeries),
    );
  });
}

List<Tween<T>>? _buildTweens<T>(
  List<T>? current,
  List<T> target, {
  required TweenBuilder<T> builder,
}) {
  return List.generate(
    target.length,
    (i) => builder(current?.getOrNull(i), target[i]),
  );
}
