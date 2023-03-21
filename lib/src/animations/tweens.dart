import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/animation.dart';

typedef TweenBuilder<T> = Tween<T> Function(T? current, T target);

List<Tween<T>>? buildTweens<T>(
  List<T>? current,
  List<T> target, {
  required TweenBuilder<T> builder,
}) =>
    List.generate(
      target.length,
      (i) => builder(current?.getOrNull(i), target[i]),
    );
