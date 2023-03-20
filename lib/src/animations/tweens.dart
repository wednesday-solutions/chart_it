import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/data/core/cartesian_data.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/animation.dart';

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
  return _buildTweens(current, target, builder: (a, b) {
    final currentValue =
        a == null || a.runtimeType != b.runtimeType ? BarSeries.zero() : a;
    return CartesianSeries.when(
      value: b,
      barSeries: () => BarSeriesTween(
        begin: currentValue as BarSeries,
        end: b as BarSeries,
      ),
    );
  });
}

List<Tween<T>>? _buildTweens<T>(
  List<T>? current,
  List<T> target, {
  required TweenBuilder<T> builder,
}) =>
    List.generate(
      target.length,
      (i) => builder(current?.getOrNull(i), target[i]),
    );
