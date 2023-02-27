import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/pie_charts/data_class/pie_data.dart';

class DoughnutPieData extends PieData with EquatableMixin {
  DoughnutPieData(super.pieceData);

  @override
  List<Object?> get props => [];
}
