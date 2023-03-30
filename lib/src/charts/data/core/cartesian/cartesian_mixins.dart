import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';

/// Provides minimum, maximum and range values for a Cartesian Chart.
///
/// Any calculations for these values, should be updated with the
/// [aggregateData] method.
///
/// A Config instance for the required Data Series can be provided by the [getConfig].
mixin CartesianDataMixin {
  double get minXValue;

  double get maxXValue;

  double get minYValue;

  double get maxYValue;

  double get minXRange;

  double get maxXRange;

  double get minYRange;

  double get maxYRange;

  void aggregateData(List<CartesianSeries> data);

  CartesianConfig? getConfig(CartesianSeries series);
}
