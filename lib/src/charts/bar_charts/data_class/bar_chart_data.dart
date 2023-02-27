import 'package:equatable/equatable.dart';
import 'package:flutter_charts/src/charts/bar_charts/data_class/bar_plot_data.dart';
import '../enum.utils.dart';

class BarChartData extends Equatable {
  final List<BarPlotData> barData;
  final String xLabel;
  final String yLabel;
  final BarOrientation barOrientation;
  final int? minX;
  final int? minY;
  final int? maxX;
  final int? maxY;
  final int? xUnitCount;
  final int? yUnitCount;
  final int? xBaseline;
  final int? yBaseline;

  const BarChartData({
      required this.barData,
      required this.xLabel,
      required this.yLabel,
      required this.barOrientation,
      this.minX,
      this.minY,
      this.maxX,
      this.maxY,
      this.xUnitCount,
      this.yUnitCount,
      this.xBaseline,
      this.yBaseline});

  @override
  List<Object?> get props => [
        barData,
        xLabel,
        yLabel,
        barOrientation,
        minX,
        minY,
        maxX,
        maxY,
        xUnitCount,
        yUnitCount,
        xBaseline,
        yBaseline
      ];
}
