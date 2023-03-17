import 'package:chart_it/src/charts/data/bars/bar_group.dart';

typedef Lerp<T> = T Function(T, T, double);

int? lerpInt(int? a, int? b, double t) {
  if (a == b || (a?.isNaN ?? false) && (b?.isNaN ?? false)) {
    return a?.toInt();
  }
  a ??= 0;
  b ??= 0;
  assert(a.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(b.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(t.isFinite, 't must be finite when interpolating between values');
  return (a + (b - a) * t).round();
}

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
  required Lerp<T> lerp,
}) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) => lerp(a[i], b[i], t));
  } else if (a != null && b != null) {
    return List.generate(
      b.length,
      (i) => lerp(i >= a.length ? b[i] : a[i], b[i], t),
    );
  } else {
    return b;
  }
}
