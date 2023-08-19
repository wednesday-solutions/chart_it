import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/painters/cartesian/bar_painter.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';

class BarSeriesState
    extends PaintingState<BarSeries, BarSeriesConfig, BarPainter> {
  BarSeriesState({
    required super.data,
    required super.config,
    required super.painter,
  });

  static BarSeriesState lerp(
    PaintingState? current,
    PaintingState target,
    double t,
  ) {
    return BarSeriesState(
      data: BarSeries.lerp(current?.data, target.data, t),
      config: target.config,
      painter: target.painter,
    );
  }

  @override
  List<Object?> get props => [super.data];
}
