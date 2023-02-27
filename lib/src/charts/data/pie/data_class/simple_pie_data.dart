import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/data/pie/data_class/pie_data.dart';

class SimplePieData extends PieData with EquatableMixin {
  SimplePieData(super.value, super.pieceColor);

  @override
  List<Object?> get props => [value, pieceColor];
}
