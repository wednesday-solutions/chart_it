import 'dart:ui';

import 'package:chart_it/src/animations/lerps.dart';
import 'package:equatable/equatable.dart';

class Candle with EquatableMixin {
  final DateTime date;
  final num open;
  final num high;
  final num low;
  final num close;
  final num volume;

  Candle({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  /// Lerps between two [Candle] objects for a factor [t].
  ///
  /// If subtypes of the two objects are not identical, then it lerps
  /// from null to [target] object's type.
  static Candle lerp(Candle? current, Candle target, double t) {
    return Candle(
      date: target.date,
      open: lerpDouble(current?.open, target.open, t) as num,
      high: lerpDouble(current?.high, target.high, t) as num,
      low: lerpDouble(current?.low, target.low, t) as num,
      close: lerpDouble(current?.close, target.close, t) as num,
      volume: lerpDouble(current?.volume, target.volume, t) as num,
    );
  }

  /// Lerps between two Lists of [Candle] for a factor [t].
  static List<Candle> lerpCandleList(
    List<Candle>? current,
    List<Candle> target,
    double t,
  ) =>
      lerpList(current, target, t, lerp: lerp);

  @override
  List<Object?> get props => [date, open, high, low, close, volume];
}
