import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';

class BarSeriesState
    extends PaintingState<BarSeries, BarSeriesConfig, BarPainter> {
  BarSeriesState({
    // super.currentData,
    required super.targetData,
    required super.config,
    required super.painter,
  });

  static BarSeriesState lerp(
    PaintingState? current,
    PaintingState target,
    double t,
  ) {
    return BarSeriesState(
      // currentData: BarSeries.lerp(current?.targetData, target.targetData, t),
      targetData: BarSeries.lerp(current?.targetData, target.targetData, t),
      config: target.config,
      painter: target.painter,
    );
  }
}
