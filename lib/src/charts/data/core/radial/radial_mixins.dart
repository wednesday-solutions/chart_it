import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';

mixin RadialDataMixin {
  double get minValue;

  double get maxValue;

  void aggregateData(List<RadialSeries> data);

  RadialConfig? getConfig(RadialSeries series);
}
