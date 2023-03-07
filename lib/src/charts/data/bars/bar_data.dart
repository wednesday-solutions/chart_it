import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data_style.dart';
import 'package:flutter_charts/src/charts/data/core/cartesian_data.dart';

class BarData extends Equatable {
  final num? startYFrom;
  final num yValue;
  final LabelMapper? label;
  final TextStyle? labelStyle;
  final BarDataStyle? barStyle;

  const BarData({
    this.startYFrom,
    required this.yValue,
    this.label,
    this.labelStyle,
    this.barStyle,
  });

  @override
  List<Object?> get props => [startYFrom, yValue, label, labelStyle, barStyle];
}
