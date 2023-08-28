import 'package:chart_it/src/charts/data/bars.dart';
import 'package:chart_it/src/charts/data/candlestick/candle.dart';
import 'package:chart_it/src/charts/data/core.dart';

/// This class defines the Data Set to be provided to the CandleStickChart
/// and the Global Styling options.
///
/// The CandleStickSeries is **mandatory** to be provided to the [CandleStickChart] widget.
///
/// See Also: [CartesianSeries]
class CandleStickSeries extends CartesianSeries<BarInteractionEvents> {
  /// Sets uniform styling for All the Bars in this [CandleStickSeries].
  ///
  /// {@macro bar_styling_order}
  // final BarDataStyle? seriesStyle;

  /// The DataSet for our CandleStickChart. It is Structured as a [BarGroup]
  /// that provides the X-Value and can contain a
  /// single or multiple group of bars.
  // final List<BarGroup> barData;

  final List<Candle> candles;

  /// This class defines the Data Set to be provided to the CandleStickChart,
  /// the Global Styling options and any interaction events that could be
  /// performed on the following Data.
  ///
  /// The CandleStickSeries is **mandatory** to be provided to the [CandleStickChart] widget.
  ///
  /// See Also: [CartesianSeries]
  CandleStickSeries({
    // this.seriesStyle,
    required this.candles,
    super.interactionEvents = const BarInteractionEvents(isEnabled: false),
  });

  /// Constructs a Factory Instance of [CandleStickSeries] without any Data.
  factory CandleStickSeries.zero() => CandleStickSeries(candles: List.empty());

  @override
  List<Object?> get props => [/*seriesStyle, barData,*/ interactionEvents];

  /// Lerps between two [CandleStickSeries] for a factor [t]
  static CandleStickSeries lerp(
      CandleStickSeries? current,
      CandleStickSeries target,
      double t,
      ) {
    return CandleStickSeries(
      // seriesStyle: BarDataStyle.lerp(
      //   current?.seriesStyle,
      //   target.seriesStyle,
      //   t,
      // ),
      candles: Candle.lerpCandleList(current?.candles, target.candles, t),
      interactionEvents: target.interactionEvents,
    );
  }
}