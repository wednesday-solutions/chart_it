import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/pie_charts/data_class/pie_data.dart';

class PieSeries extends Equatable {
  final List<PieData> pieData;
  final String Function(int, num)? labelMapper;

  const PieSeries({required this.pieData, this.labelMapper});

  @override
  List<Object?> get props => [pieData, labelMapper];
}
