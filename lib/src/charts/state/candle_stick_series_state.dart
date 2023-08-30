import 'package:chart_it/src/charts/data/candle_sticks.dart';
import 'package:chart_it/src/charts/painters/cartesian/candle_stick_painter.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';

class CandleStickState extends PaintingState<CandleStickSeries,
    CandleStickSeriesConfig, CandleStickPainter> {
  CandleStickState({
    required super.data,
    required super.config,
    required super.painter,
  });

  static CandleStickState lerp(
    PaintingState? current,
    PaintingState target,
    double t,
  ) {
    return CandleStickState(
      data: CandleStickSeries.lerp(current?.data, target.data, t),
      config: target.config,
      painter: target.painter,
    );
  }

  @override
  List<Object?> get props => [super.data];
}
