import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'enum.utils.dart';

class Dataset extends Equatable {
  final List<Type> xAxisValues;
  final VerticalBarData verticalBarData;
  final String xLabel;
  final String yLabel;
  final Colors backgroundColor;
  final BarOrientation barOrientation;
  final int minX;
  final int minY;
  final int maxX;
  final int maxY;
  final int xUnitCount;
  final int yUnitCount;
  final int xBaseline;
  final int yBaseline;

  const Dataset(
      this.xAxisValues,
      this.verticalBarData,
      this.xLabel,
      this.yLabel,
      this.backgroundColor,
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
        xAxisValues,
        verticalBarData,
        xLabel,
        yLabel,
        backgroundColor,
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

class VerticalBarData extends Equatable {
  final int fromY;
  final int toY;
  final Colors color;
  final int borderRadius;
  final int width;
  final Gradient gradient;
  final RearBarChart rearBarChart;
  final GroupAlignment groupAlignment;

  const VerticalBarData(this.fromY, this.toY, this.color, this.borderRadius,
      this.width, this.gradient, this.rearBarChart, this.groupAlignment);

  @override
  List<Object?> get props => [
        fromY,
        toY,
        color,
        borderRadius,
        width,
        gradient,
        rearBarChart,
        groupAlignment
      ];
}

class RearBarChart extends Equatable {
  final int fromY;
  final int toY;
  final Colors color;
  final int borderRadius;
  final int width;
  final Gradient gradient;

  const RearBarChart(this.fromY, this.toY, this.color, this.borderRadius,
      this.width, this.gradient);

  @override
  List<Object?> get props => [fromY, toY, color, borderRadius, width, gradient];
}
