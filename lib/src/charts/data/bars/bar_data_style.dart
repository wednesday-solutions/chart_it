import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BarDataStyle extends Equatable {
  final double? barWidth;
  final Color? barColor;
  final Gradient? gradient;
  final double? strokeWidth;
  final Color? strokeColor;
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
