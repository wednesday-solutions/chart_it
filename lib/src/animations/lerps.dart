import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/extensions/primitives.dart';

typedef Lerp<T> = T Function(T?, T, double);

mixin ZeroValueProvider<T> {
  T get zeroValue;
}

int? lerpInt(int? a, int? b, double t) => lerpDouble(a, b, t)?.round();

List<BarGroup> lerpBarGroupList(
  List<BarGroup>? a,
  List<BarGroup> b,
  double t,
) =>
    lerpList(a, b, t, lerp: (a, b, t) => BarGroup.lerp(a, b, t));

List<T> lerpList<T>(
  List<T>? a,
  List<T> b,
  double t, {
  required Lerp<T> lerp,
}) =>
    List.generate(b.length, (i) => lerp(a?.getOrNull(i), b[i], t));
