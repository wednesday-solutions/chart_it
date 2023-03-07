import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/src/charts/data/core/radial_data.dart';
import 'package:flutter_charts/src/charts/data/pie/slice_data.dart';
import 'package:flutter_charts/src/charts/data/pie/slice_data_style.dart';

typedef DonutLabel = String Function();

class PieSeries extends RadialSeries with EquatableMixin {
  final double donutRadius;
  final Color donutSpaceColor;
  final DonutLabel? donutLabel;
  final TextStyle? donutLabelStyle;
  final SliceDataStyle? seriesStyle;
  final List<SliceData> slices;

  PieSeries({
    this.donutRadius = 0.0,
    this.donutSpaceColor = Colors.transparent,
    this.donutLabel,
    this.donutLabelStyle,
    this.seriesStyle,
    required this.slices,
  });

  @override
  List<Object?> get props => [
        donutRadius,
        donutSpaceColor,
        donutLabel,
        donutLabelStyle,
        seriesStyle,
        slices,
      ];
}
