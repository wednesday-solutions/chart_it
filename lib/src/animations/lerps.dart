import 'dart:ui';

import 'package:chart_it/src/extensions/primitives.dart';

typedef Lerp<T> = T Function(T?, T, double);

mixin ZeroValueProvider<T> {
  T get zeroValue;
}

int? lerpInt(int? current, int? target, double t) =>
    lerpDouble(current, target, t)?.round();

List<T> lerpList<T>(
  List<T>? current,
  List<T> target,
  double t, {
  required Lerp<T> lerp,
}) {
  return List.generate(
      target.length, (i) => lerp(current?.getOrNull(i), target[i], t));
}
