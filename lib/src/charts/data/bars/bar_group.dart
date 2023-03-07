import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/data/bars/bar_data_style.dart';
import 'package:flutter_charts/src/charts/data/core/cartesian_data.dart';

enum BarGroupArrangement { series, stack }

abstract class BarGroup {
  final num xValue;
  final LabelMapper? label;
  final TextStyle? labelStyle;
  final BarDataStyle? groupStyle;

  BarGroup({
    required this.xValue,
    this.label,
    this.labelStyle,
    this.groupStyle,
  });
}
