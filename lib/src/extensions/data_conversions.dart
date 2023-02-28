import 'package:flutter_charts/src/charts/data/bars/bar_data.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_group.dart';
import 'package:flutter_charts/src/charts/data/bars/multi_bar.dart';
import 'package:flutter_charts/src/charts/data/bars/simple_bar.dart';

extension YValueGetter on BarGroup {
  // Helper method to strip group data into data object with raw values
  List<BarData> yValues() {
    var y = <BarData>[];

    switch (runtimeType) {
      case SimpleBar:
        y.add((this as SimpleBar).yValue);
        break;
      case MultiBar:
        y.addAll((this as MultiBar).yValues);
        break;
    }

    return y;
  }
}
