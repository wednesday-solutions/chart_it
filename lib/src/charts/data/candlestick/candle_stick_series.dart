import 'dart:math';

import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/candlestick/candle.dart';
import 'package:chart_it/src/charts/data/candlestick/candle_style.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';

/// This class defines the Data Set to be provided to the CandleStickChart
/// and the Global Styling options.
///
/// The CandleStickSeries is **mandatory** to be provided to the [CandleStickChart] widget.
///
/// See Also: [CartesianSeries]
class CandleStickSeries extends CartesianSeries<BarInteractionEvents> {
  /// Sets uniform styling for All the Candles in this [CandleStickSeries].
  ///
  /// {@macro candle_stick_styling_order}
  final CandleStyle? seriesStyle;

  /// The DataSet for our CandleStickChart. It contains the data for each candle.
  final List<Candle> candles;

  /// This class defines the Data Set to be provided to the CandleStickChart,
  /// the Global Styling options and any interaction events that could be
  /// performed on the following Data.
  ///
  /// The CandleStickSeries is **mandatory** to be provided to the [CandleStickChart] widget.
  ///
  /// See Also: [CartesianSeries]
  CandleStickSeries({
    this.seriesStyle,
    required this.candles,
    super.interactionEvents = const BarInteractionEvents(isEnabled: false),
  });

  /// Constructs a Factory Instance of [CandleStickSeries] without any Data.
  factory CandleStickSeries.zero() => CandleStickSeries(candles: List.empty());

  @override
  List<Object?> get props => [candles, seriesStyle, interactionEvents];

  /// Lerps between two [CandleStickSeries] for a factor [t]
  static CandleStickSeries lerp(
    CandleStickSeries? current,
    CandleStickSeries target,
    double t,
  ) {
    return CandleStickSeries(
      seriesStyle: CandleStyle.lerp(
        current?.seriesStyle,
        target.seriesStyle,
        t,
      ),
      candles: Candle.lerpCandleList(current?.candles, target.candles, t),
      interactionEvents: target.interactionEvents,
    );
  }
}

/// Defines [CandleStickSeries] specific data variables, which are utilized
/// when drawing a [CandleStickChart].
///
/// Also calculates the minimum & maximum value in a given list of [Candle].
class CandleStickSeriesConfig extends CartesianConfig {
  /// Returns the value of this [SliceData] in [onUpdate].
  void calcHighLowRange(
    List<Candle> candles,
    Function(double minAmt, double maxAmt) onUpdate,
  ) {
    for (var i = 0; i < candles.length; i++) {
      // TODO: Find the highest and lowest based on high & low params
      final candle = candles[i];

      var minAmt = double.infinity;
      var maxAmt = 0.0;

      minAmt = min(minAmt, candle.low.toDouble());
      maxAmt = max(maxAmt, candle.high.toDouble());

      onUpdate(minAmt, maxAmt);
    }
  }

  @override
  List<Object?> get props => [];
}
