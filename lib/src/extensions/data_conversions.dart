import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/bars/multi_bar.dart';
import 'package:chart_it/src/charts/data/bars/simple_bar.dart';

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
