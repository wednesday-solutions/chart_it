import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

typedef SliceMapper = String Function(num percentage, num value);

abstract class RadialSeries {}

class RadialChartStyle extends Equatable {
  final Color backgroundColor;
  final double initAngle;
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

class PolarAxis extends RadialAxis with EquatableMixin {
  PolarAxis({
    required super.tickStyle,
    super.gridLineStrokeColor,
    super.gridLineStrokeWidth,
  });

  @override
  List<Object?> get props => [
        super.tickStyle,
        super.gridLineStrokeColor,
        super.gridLineStrokeWidth,
      ];

  PolarAxis copyWith(
    TextStyle? tickStyle,
    Color? gridLineStrokeColor,
    double? gridLineStrokeWidth,
  ) {
    return PolarAxis(
      tickStyle: tickStyle ?? super.tickStyle,
      gridLineStrokeColor: gridLineStrokeColor ?? super.gridLineStrokeColor,
      gridLineStrokeWidth: gridLineStrokeWidth ?? super.gridLineStrokeWidth,
    );
  }
}

class RadarAxis extends RadialAxis with EquatableMixin {
  Color angleLineStrokeColor;
  double angleLineStrokeWidth;
  TextStyle angleLabelStyle;

  RadarAxis({
    required super.tickStyle,
    required this.angleLabelStyle,
    super.gridLineStrokeColor,
    super.gridLineStrokeWidth,
    this.angleLineStrokeColor = Colors.black45,
    this.angleLineStrokeWidth = 1.0,
  });

  @override
  List<Object?> get props => [
        super.tickStyle,
        angleLabelStyle,
        super.gridLineStrokeColor,
        super.gridLineStrokeWidth,
        angleLineStrokeColor,
        angleLineStrokeWidth,
      ];

  RadarAxis copyWith({
    TextStyle? tickStyle,
    Color? gridLineStrokeColor,
    double? gridLineStrokeWidth,
    Color? angleLineStrokeColor,
    double? angleLineStrokeWidth,
    TextStyle? angleLabelStyle,
  }) {
    return RadarAxis(
      tickStyle: tickStyle ?? super.tickStyle,
      gridLineStrokeColor: gridLineStrokeColor ?? super.gridLineStrokeColor,
      gridLineStrokeWidth: gridLineStrokeWidth ?? super.gridLineStrokeWidth,
      angleLineStrokeColor: angleLineStrokeColor ?? this.angleLineStrokeColor,
      angleLineStrokeWidth: angleLineStrokeWidth ?? this.angleLineStrokeWidth,
      angleLabelStyle: angleLabelStyle ?? this.angleLabelStyle,
    );
  }
}

abstract class RadialAxis {
  final TextStyle tickStyle;
  final Color gridLineStrokeColor;
  final double gridLineStrokeWidth;

  RadialAxis({
    required this.tickStyle,
    this.gridLineStrokeColor = Colors.black45,
    this.gridLineStrokeWidth = 1.0,
  });
}
