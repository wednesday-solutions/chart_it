import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/extensions/primitives.dart';

typedef Lerp<T> = T Function(T, T, double);

mixin Interpolatable<T> {
  T lerp(T a, T b, double t);

  T get zeroValue;
}

int? lerpInt(int? a, int? b, double t) => lerpDouble(a, b, t)?.round();

List<BarGroup>? lerpBarGroupList(
  List<BarGroup>? a,
  List<BarGroup>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: (a, b, t) => a.lerp(a, b, t));

List<T>? lerpList<T>(
  List<T>? a,
  List<T>? b,
    double t, {
  required T zeroValue,
  required Lerp<T> lerp,
}) {
  if (a != null && b != null) {
    return List.generate(b.length, (i) => lerp(a.get(i, zeroValue), b[i], t));
  } else {
    return b;
  }
}
