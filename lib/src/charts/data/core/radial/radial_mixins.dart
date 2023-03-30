import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';

/// Provides minimum and maximum values for a Radial Chart.
///
/// Any calculations for these values, should be updated with the
/// [aggregateData] method.
///
/// A Config instance for the required Data Series can be provided by the [getConfig].
mixin RadialDataMixin {
  double get minValue;

  double get maxValue;

  void aggregateData(List<RadialSeries> data);

  RadialConfig? getConfig(RadialSeries series);
}
