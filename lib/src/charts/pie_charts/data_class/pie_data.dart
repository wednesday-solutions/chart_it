import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/pie_charts/data_class/pie_style.dart';

class PieData extends Equatable {
  final num value;
  final PieStyle? pieStyle;

  const PieData({required this.value, this.pieStyle});

  @override
  List<Object?> get props => [value, pieStyle];
}
