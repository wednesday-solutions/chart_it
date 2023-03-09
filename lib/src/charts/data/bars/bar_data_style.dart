import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/widgets/bar_chart.dart';

/// Encapsulates all the Styling options required for a [BarChart]
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

  @override
  List<Object?> get props =>
      [barWidth, barColor, gradient, strokeWidth, strokeColor, cornerRadius];
}
