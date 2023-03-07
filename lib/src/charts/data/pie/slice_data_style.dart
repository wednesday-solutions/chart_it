import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SliceDataStyle extends Equatable {
  final double radius;
  final Color color;
  final double strokeWidth;
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
