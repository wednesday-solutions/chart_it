import 'dart:math';

import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/bars/simple_bar.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';
import 'package:flutter/cupertino.dart';

extension YValueGetter on BarGroup {
  // Helper method to strip group data into data object with raw values
  List<BarData> yValues() {
    switch (runtimeType) {
      case SimpleBar:
        return [(this as SimpleBar).yValue];
      case MultiBar:
        return (this as MultiBar).yValues;
      default:
        throw ArgumentError('Y values must be present!');
    }
  }
}

extension CartesianIterators on List<CartesianSeries> {
  int maxIterations() {
    var count = 0;
    forEach((series) {
      series.when(
        onBarSeries: (series) {
          count = max(count, series.barData.length);
        },
      );
    });
    return count;
  }
}

extension RadialIterators on List<RadialSeries> {
  int maxIterations() {
    var count = 0;
    forEach((series) {
      series.when(
        onPieSeries: (series) {
          count = max(count, series.slices.length);
        },
      );
    });
    return count;
  }
}

EdgeInsets maxInsets(EdgeInsets a, EdgeInsets b) {
  return EdgeInsets.only(
    left: max(a.left, b.left),
    right: max(a.right, b.right),
    top: max(a.top, b.top),
    bottom: max(a.bottom, b.bottom),
  );
}
