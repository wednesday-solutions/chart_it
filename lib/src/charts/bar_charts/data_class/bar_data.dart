import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/bar_charts/data_class/rear_bar_dart.dart';

class BarData extends Equatable {
  final int? fromY;
  final int toY;
  final Color? color;
  final int? borderRadius;
  final int? width;
  final Gradient? gradient;
  final RearBarData? rearBarChart;

  const BarData(this.toY, this.fromY, this.color, this.borderRadius, this.width,
      this.gradient, this.rearBarChart);

  @override
  List<Object?> get props =>
      [fromY, toY, color, borderRadius, width, gradient, rearBarChart];
}