import 'dart:ui';

import 'package:chart_it/src/charts/data/pie/pie_series.dart';
import 'package:chart_it/src/charts/data/pie/slice_data.dart';
import 'package:chart_it/src/charts/widgets/pie_chart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Encapsulates all the Styling options required for a [PieChart].
/// {@template slice_styling_order}
/// The order of priority in styling is
/// 1. style in [SliceData]
/// 2. seriesStyle in [PieSeries]
/// 4. Default [SliceDataStyle] Style
/// {@endtemplate}
class SliceDataStyle extends Equatable {
  /// The radius of the Pie/Slice.
  /// Maximum Radius size will be auto-calculated and
  /// will prevent Slice to Clip Out of Bounds
  final double radius;

  /// The color of the slice
  final Color? color;

  /// The Gradient of the slice
  final Gradient? gradient;

  /// The Width of the Stroke/Border around the Pie/Slice
  final double? strokeWidth;

  /// The Color of the Stroke/Border around the Pie/Slice
  final Color? strokeColor;

  /// Encapsulates all the Styling options required for a [PieChart].
  /// {@macro slice_styling_order}
  const SliceDataStyle({
    required this.radius,
    this.color = Colors.amber,
    this.gradient,
    this.strokeColor = Colors.deepOrange,
    this.strokeWidth = 0.0,
  });

  @override
  List<Object?> get props =>
      [radius, color, gradient, strokeWidth, strokeColor];

  /// Lerps between two [SliceDataStyle]'s for a factor [t]
  static SliceDataStyle? lerp(
    SliceDataStyle? current,
    SliceDataStyle? target,
    double t,
  ) {
    if (target != null) {
      return SliceDataStyle(
        radius: lerpDouble(current?.radius, target.radius, t) ?? 0,
        color: Color.lerp(current?.color, target.color, t),
        gradient: Gradient.lerp(current?.gradient, target.gradient, t),
        strokeWidth: lerpDouble(current?.strokeWidth, target.strokeWidth, t),
        strokeColor: Color.lerp(current?.strokeColor, target.strokeColor, t),
      );
    }
    return null;
  }
}
