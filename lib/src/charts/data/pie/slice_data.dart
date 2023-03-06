import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/core/radial_data.dart';
import 'package:flutter_charts/src/charts/data/pie/slice_data_style.dart';

class SliceData extends Equatable {
  final SliceDataStyle? style;
  final SliceMapper? label;
  final num value;

  const SliceData({
    required this.value,
    this.label,
    this.style,
  });

  @override
  List<Object?> get props => [style, label, value];
}
