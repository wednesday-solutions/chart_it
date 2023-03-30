import 'package:chart_it/src/extensions/primitives.dart';
import 'package:flutter/animation.dart';

/// Defines method signature to return a [Tween] of type [T] for
/// [current] and [target] values
typedef TweenBuilder<T> = Tween<T> Function(T? current, T target);

/// Constructs a List of [Tween] for two Lists of type [T].
/// The [builder] method must be provided to construct a Tween for object of type [T].
List<Tween<T>>? buildTweens<T>(
  List<T>? current,
  List<T> target, {
  required TweenBuilder<T> builder,
}) =>
    List.generate(
      target.length,
      (i) => builder(current?.getOrNull(i), target[i]),
    );
