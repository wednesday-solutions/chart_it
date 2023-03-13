import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/data/pie/pie_series.dart';
import 'package:flutter_charts/src/charts/data/pie/slice_data.dart';
import 'package:flutter_charts/src/charts/widgets/pie_chart.dart';

/// Encapsulates all the Styling options required for a [PieChart]
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
  final Color color;

  /// The Width of the Stroke/Border around the Pie/Slice
  final double strokeWidth;

  /// The Color of the Stroke/Border around the Pie/Slice
  final Color strokeColor;

  const SliceDataStyle({
    required this.radius,
    this.color = Colors.amber,
    this.strokeColor = Colors.deepOrange,
    this.strokeWidth = 0.0,
  });

  @override
  List<Object?> get props => [radius, color, strokeWidth, strokeColor];
}
