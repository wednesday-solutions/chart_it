import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'pie_series_style.dart';

class PieChartStyle extends Equatable {
  final Color? backgroundColor;
  final PieSeriesStyle pieSeriesStyle;

  const PieChartStyle({this.backgroundColor, required this.pieSeriesStyle});

  @override
  List<Object?> get props => [backgroundColor, pieSeriesStyle];
}
