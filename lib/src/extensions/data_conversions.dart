import 'package:flutter_charts/src/charts/data/bars/bar_group.dart';
import 'package:flutter_charts/src/charts/data/bars/multi_bar.dart';
import 'package:flutter_charts/src/charts/data/bars/simple_bar.dart';
import 'package:flutter_charts/src/charts/data/core/raw_data.dart';

extension DataStripper on List<BarGroup> {
  // Helper method to strip group data into data object with raw values
  List<RawSeries> rawData() {
    return map((group) {
      // Initialize a wrapper array to collect the yValues
      var yData = <num>[];

      if (group is SimpleBar) {
        // Simple bar has only one yValue so we add it
        yData.add(group.yValue);
      } else if (group is MultiBar) {
        // Multi bar can have multiple y Values so we will add them all
        yData.addAll(group.yValues.map((data) => data.yValue).toList());
      }

      return RawSeries(xValue: group.xValue, yValues: yData);
    }).toList();
  }
}
