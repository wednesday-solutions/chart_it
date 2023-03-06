import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/core/radial_data.dart';
import 'package:flutter_charts/src/charts/data/pie/slice_data.dart';
import 'package:flutter_charts/src/charts/data/pie/slice_data_style.dart';

class PieSeries extends RadialSeries with EquatableMixin {
  final SliceDataStyle? seriesStyle;
  final List<SliceData> slices;

  PieSeries({
    this.seriesStyle,
    required this.slices,
  });

  @override
  List<Object?> get props => [seriesStyle, slices];
}
