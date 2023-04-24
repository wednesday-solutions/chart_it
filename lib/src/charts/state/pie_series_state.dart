import 'package:chart_it/src/charts/data/pie.dart';
import 'package:chart_it/src/charts/painters/radial/pie_painter.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';

class PieSeriesState
    extends PaintingState<PieSeries, PieSeriesConfig, PiePainter> {
  PieSeriesState({
    required super.data,
    required super.config,
    required super.painter,
  });

  static PieSeriesState lerp(
    PaintingState? current,
    PaintingState target,
    double t,
  ) {
    return PieSeriesState(
      data: PieSeries.lerp(current?.data, target.data, t),
      config: target.config,
      painter: target.painter,
    );
  }

  @override
  List<Object?> get props => [super.data];
}
