import 'package:chart_it/src/animations/lerps.dart';
import 'package:chart_it/src/charts/state/bar_series_state.dart';
import 'package:chart_it/src/charts/state/pie_series_state.dart';

abstract class PaintingState<SERIES, CONFIG, PAINTER> {
  SERIES data;
  CONFIG config;
  PAINTER painter;

  PaintingState({
    required this.data,
    required this.config,
    required this.painter,
  });

  static PaintingState lerp(
    PaintingState? current,
    PaintingState target,
    double t,
  ) {
    final currentValue =
        current == null || current.runtimeType != target.runtimeType
            ? null
            : current;
    return target._when(
      barState: () => BarSeriesState.lerp(currentValue, target, t),
      pieState: () => PieSeriesState.lerp(currentValue, target, t),
    );
  }

  /// Lerps between two Lists of [PaintingState] for a factor [t].
  static List<PaintingState> lerpStateList(
    List<PaintingState>? current,
    List<PaintingState> target,
    double t,
  ) =>
      lerpList(current, target, t, lerp: lerp);

  /// Helper method to capture [runtimeType] checks for the subtype of
  /// [PaintingState] object, and provides callback method for the matching type.
  T _when<T>({
    required T Function() barState,
    required T Function() pieState,
  }) {
    switch (runtimeType) {
      case BarSeriesState:
        return barState();
      case PieSeriesState:
        return pieState();
      default:
        throw TypeError();
    }
  }
}
