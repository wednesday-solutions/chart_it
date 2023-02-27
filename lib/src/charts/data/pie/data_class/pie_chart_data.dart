import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/pie/data_class/pie_data.dart';

class PieChartData extends Equatable {
  final List<PieData> pieData;
  final int strokeWidth;

  const PieChartData({required this.pieData, required this.strokeWidth});

  @override
  List<Object?> get props => [];
}
