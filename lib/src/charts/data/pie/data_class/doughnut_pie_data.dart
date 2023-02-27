import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/pie/data_class/pie_data.dart';

class DoughnutPieData extends PieData with EquatableMixin {
  DoughnutPieData(super.value, super.pieceColor);

  @override
  List<Object?> get props => [value, pieceColor];
}
