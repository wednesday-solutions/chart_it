import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'enum.utils.dart';

class BarChartData extends Equatable {
  final List<BarData> barData;
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

  const BarChartData(
      this.barData,
      this.xLabel,
      this.yLabel,
      this.barOrientation,
      this.minX,
      this.minY,
      this.maxX,
      this.maxY,
      this.xUnitCount,
      this.yUnitCount,
      this.xBaseline,
      this.yBaseline);

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

abstract class BarPlotData {
  final int x;

  BarPlotData(this.x);
}

class SimpleBarPlotData extends BarPlotData {
  SimpleBarPlotData(super.x, this.yBarData);

  final BarData yBarData;
}

class GroupedBarPlotData extends BarPlotData {
  GroupedBarPlotData(super.x, this.yBarData);

  final List<BarData> yBarData;
}

class StackedBarPlotData extends BarPlotData {
  StackedBarPlotData(super.x, this.yBarData);

  final List<BarData> yBarData;
}

class BarData extends Equatable {
  final int? fromY;
  final int toY;
  final Color? color;
  final int? borderRadius;
  final int? width;
  final Gradient? gradient;
  final RearBarData? rearBarChart;

  const BarData(
      this.toY, this.fromY, this.color, this.borderRadius, this.width, this.gradient, this.rearBarChart);

  @override
  List<Object?> get props =>
      [fromY, toY, color, borderRadius, width, gradient, rearBarChart];
}

class RearBarData extends Equatable {
  final int? fromY;
  final int toY;
  final Colors? color;
  final int? borderRadius;
  final int? width;
  final Gradient? gradient;

  const RearBarData(this.fromY, this.toY, this.color, this.borderRadius,
      this.width, this.gradient);

  @override
  List<Object?> get props => [fromY, toY, color, borderRadius, width, gradient];
}
