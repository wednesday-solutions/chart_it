import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RearBarData extends Equatable {
  final int? fromY;
  final int toY;
  final Colors? color;
  final int? borderRadius;
  final int? width;
  final Gradient? gradient;

  const RearBarData({this.fromY, required this.toY, this.color, this.borderRadius,
    this.width, this.gradient});

  @override
  List<Object?> get props => [fromY, toY, color, borderRadius, width, gradient];
}