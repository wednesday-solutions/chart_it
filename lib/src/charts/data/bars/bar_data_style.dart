import 'dart:ui';

import 'package:chart_it/src/charts/data/bars/bar_data.dart';
import 'package:chart_it/src/charts/data/bars/bar_group.dart';
import 'package:chart_it/src/charts/data/bars/bar_series.dart';
import 'package:chart_it/src/charts/widgets/bar_chart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// Encapsulates all the Styling options required for a [BarChart]
/// {@template bar_styling_order}
/// The order of priority in styling is
/// 1. barStyle in [BarData]
/// 2. groupStyle in [BarGroup]
/// 3. seriesStyle in [BarSeries]
/// 4. Default [BarDataStyle] Style
/// {@endtemplate}
class BarDataStyle extends Equatable {
  /// The Width of the Bar. This value should range between 0.0 & 1.0.
  final double? barWidth;

  /// The fill color of the Bar
  final Color? barColor;

  /// The gradient fill of the Bar
  final Gradient? gradient;

  /// The Width of the Stroke/Border around the Bar
  final double? strokeWidth;

  /// The Color of the Stroke/Border around the Bar
  final Color? strokeColor;

  /// Radius for the Bar Rectangle's Corners
  final BorderRadius? cornerRadius;

  const BarDataStyle({
    this.barWidth,
    this.barColor,
    this.gradient,
    this.strokeWidth,
    this.strokeColor,
    this.cornerRadius,
  });

  static BarDataStyle lerp(
    BarDataStyle? current,
    BarDataStyle? target,
    double t,
  ) {
    return BarDataStyle(
      barWidth: lerpDouble(current?.barWidth, target?.barWidth, t),
      barColor: Color.lerp(current?.barColor, target?.barColor, t),
      gradient: Gradient.lerp(current?.gradient, target?.gradient, t),
      strokeWidth: lerpDouble(current?.strokeWidth, target?.strokeWidth, t),
      strokeColor: Color.lerp(current?.strokeColor, target?.strokeColor, t),
      cornerRadius: BorderRadius.lerp(current?.cornerRadius, target?.cornerRadius, t),
    );
  }

  @override
  List<Object?> get props =>
      [barWidth, barColor, gradient, strokeWidth, strokeColor, cornerRadius];
}
