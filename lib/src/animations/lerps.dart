import 'dart:ui';

import 'package:chart_it/src/extensions/primitives.dart';

/// Defines method signature of a Lerp Function
typedef Lerp<T> = T Function(T?, T, double);

/// Lerps between two integer values for factor [t]
int? lerpInt(int? current, int? target, double t) =>
    lerpDouble(current, target, t)?.round();

/// Lerps between two lists of Type [T].
/// The [lerp] method must be provided to lerp between the values.
List<T> lerpList<T>(
  List<T>? current,
  List<T> target,
  double t, {
  required Lerp<T> lerp,
}) =>
    List.generate(
      target.length,
      (i) => lerp(current?.getOrNull(i), target[i], t),
    );
