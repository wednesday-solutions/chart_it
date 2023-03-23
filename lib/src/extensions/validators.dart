import 'package:chart_it/src/charts/data/bars/bar_series.dart';

dynamic _EmptyCallback() {}

dynamic whereSeries(
  Type type, {
  dynamic Function() onBarSeries = _EmptyCallback,
  dynamic Function() onLineSeries = _EmptyCallback,
}) {
  switch (type) {
    case BarSeries:
      onBarSeries();
      break;
    default:
      throw TypeError();
  }
}

extension AsExtension on Object? {
  X as<X>() => this as X;

  X? asOrNull<X>() {
    var currObject = this;
    return currObject is X ? currObject : null;
  }
}
