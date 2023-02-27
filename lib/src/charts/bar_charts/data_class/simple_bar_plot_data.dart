import 'package:equatable/equatable.dart';
import 'bar_data.dart';
import 'bar_plot_data.dart';

class SimpleBarPlotData extends BarPlotData with EquatableMixin {
  SimpleBarPlotData(super.x, this.yBarData);

  final BarData yBarData;

  @override
  List<Object?> get props => [x, yBarData];
}