import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';

/// Provides minimum, maximum and range values for a Cartesian Chart.
///
/// Any calculations for these values, should be updated with the
/// [aggregateData] method.
///
/// A Config instance for the required Data Series can be provided by the [getConfig].
// mixin CartesianDataMixin {
//   double _minXValue = 0;
//   double get minXValue;
//   set minXValue(double value) {
//     _minXValue = value;
//   }
//
//   double _maxXValue = 0;
//   double get maxXValue;
//   set maxXValue(double value) {
//     _maxXValue = value;
//   }
//
//   double _minYValue = 0;
//   double get minYValue;
//   set minYValue(double value) {
//     _minYValue = value;
//   }
//
//   double _maxYValue = 0;
//   double get maxYValue;
//   set maxYValue(double value) {
//     _maxYValue = value;
//   }
//
//   double _minXRange = 0;
//   double get minXRange;
//   set minXRange(double value) {
//     _minXRange = value;
//   }
//
//   double _maxXRange = 0;
//   double get maxXRange;
//   set maxXRange(double value) {
//     _maxXRange = value;
//   }
//
//   double _minYRange = 0;
//   double get minYRange => _minYRange;
//   set minYRange(double value) {
//     _minYRange = value;
//   }
//
//   double _maxYRange = 0;
//   double get maxYRange;
//   set maxYRange(double value) {
//     _maxYRange = value;
//   }
//
//   void aggregateData(List<CartesianSeries> data);
//
//   CartesianConfig? getConfig(CartesianSeries series);
//
//   lerp(double t) {
//
//   }
// }
