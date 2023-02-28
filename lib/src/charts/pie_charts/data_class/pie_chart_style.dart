import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'chart_style.dart';

class PieChartStyle extends Equatable {
  final Color? backgroundColor;
  final ChartStyle pieStyle;

  const PieChartStyle({this.backgroundColor, required this.pieStyle});

  @override
  List<Object?> get props => [backgroundColor];
}
