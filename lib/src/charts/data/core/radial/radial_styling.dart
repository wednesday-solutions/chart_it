import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Provides the Styling options for any Radial Chart.
///
/// Customization Options include BackgroundColor, Start Angle and Axis Styling.
class RadialChartStyle extends Equatable {
  /// The Background Color of the Chart.
  final Color backgroundColor;

  /// The Angle from which the Initial Data Should begin.
  /// Defaults to zero and starts Vertically Upright.
  final double initAngle;

  /// Styling for the Axis Lines.
  final RadialAxis? axis;

  const RadialChartStyle({
    this.backgroundColor = const Color(0xFFFFECD9),
    this.initAngle = 0.0,
    this.axis,
  }) : assert(
          initAngle >= 0.0 || initAngle < 360.0,
          "initAngle should be between 0 to 360 degrees",
        );

  @override
  List<Object> get props => [backgroundColor, initAngle];

  RadialChartStyle copyWith({
    Color? backgroundColor,
    double? initAngle,
  }) {
    return RadialChartStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      initAngle: initAngle ?? this.initAngle,
    );
  }
}
