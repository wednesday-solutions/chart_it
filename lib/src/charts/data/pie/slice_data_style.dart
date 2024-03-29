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

  /// Defines the Position of the Label for Slice
  /// Along the length of the radius.
  final double? labelPosition;

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
    this.labelPosition,
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
    double donutRadius,
    double t,
  ) {
    if (target != null) {
      var shouldLerpFromDonut =
          donutRadius > 0.0 && donutRadius > (current?.radius ?? 0);
      var beginRadius = shouldLerpFromDonut ? donutRadius : current?.radius;
      var beginLabel =
          shouldLerpFromDonut ? donutRadius : current?.labelPosition;
      return SliceDataStyle(
        radius: lerpDouble(beginRadius, target.radius, t) ?? 0,
        labelPosition: lerpDouble(beginLabel, target.labelPosition, t),
        color: Color.lerp(current?.color, target.color, t),
        gradient: Gradient.lerp(current?.gradient, target.gradient, t),
        strokeWidth: lerpDouble(current?.strokeWidth, target.strokeWidth, t),
        strokeColor: Color.lerp(current?.strokeColor, target.strokeColor, t),
      );
    }
    return null;
  }
}
