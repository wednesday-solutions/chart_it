import 'dart:ui';

import 'package:equatable/equatable.dart';

class CandleStyle extends Equatable {
  final bool? roundedTips;
  final double? wickWidth;
  final double? bodyWidth;

  final Color? bullColor;
  final Color? bearColor;
  final Color? neutralColor;

  const CandleStyle({
    this.roundedTips,
    this.wickWidth,
    this.bodyWidth,
    this.bullColor,
    this.bearColor,
    this.neutralColor,
  });

  /// Lerps between two [BarDataStyle]'s for a factor [t]
  static CandleStyle? lerp(
    CandleStyle? current,
    CandleStyle? target,
    double t,
  ) {
    if (target != null) {
      return CandleStyle(
        roundedTips: target.roundedTips,
        wickWidth: lerpDouble(current?.wickWidth, target.wickWidth, t),
        bodyWidth: lerpDouble(current?.bodyWidth, target.bodyWidth, t),
        bullColor: Color.lerp(current?.bullColor, target.bullColor, t),
        bearColor: Color.lerp(current?.bearColor, target.bearColor, t),
        neutralColor: Color.lerp(current?.neutralColor, target.neutralColor, t),
      );
    }
    return null;
  }

  @override
  List<Object?> get props => [
        roundedTips,
        wickWidth,
        bodyWidth,
        bullColor,
        bearColor,
        neutralColor,
      ];
}
