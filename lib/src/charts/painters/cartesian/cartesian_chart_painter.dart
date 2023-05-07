import 'dart:math';

import 'package:chart_it/src/charts/constants/defaults.dart';
import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:chart_it/src/charts/state/bar_series_state.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
import 'package:chart_it/src/extensions/primitives.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CartesianChartPainter {
  CartesianChartStyle style;
  List<PaintingState> states;
  CartesianRangeResult rangeData;

  late Paint _bgPaint;
  late Paint _gridBorder;
  late Paint _gridTick;
  late Paint _axisPaint;

  double get _labelPlacementOffset => style.axisStyle!.tickLength + 15;

  CartesianChartPainter({
    required this.style,
    required this.states,
    required this.rangeData,
  }) {
    _bgPaint = Paint();
    _gridBorder = Paint()..style = PaintingStyle.stroke;
    _gridTick = Paint()..style = PaintingStyle.stroke;
    _axisPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
  }

  void paint(Canvas canvas, Size size) {
    // Calculate constraints for the graph
    late final _TextPainterLayoutData labelPainters;
    final geometryData = _calculateGraphConstraints(size, (UnitData unitData) {
      labelPainters = _layoutLabels(
        canvas,
        unitData,
      );

      return _calculateLabelInsets(unitData, labelPainters, size);
    });

    // Paint the background
    // var bg = Paint()..color = style.backgroundColor;
    canvas.clipRect(Offset.zero & size);
    canvas.drawPaint(_bgPaint..color = style.backgroundColor);

    _drawGridLines(canvas, geometryData);

    // Finally for every data series, we will construct a painter and handover
    // the canvas to them to draw the data sets into the required chart
    for (var i = 0; i < states.length; i++) {
      var state = states[i];
      if (state is BarSeriesState) {
        state.painter.paint(
          lerpSeries: state.data,
          canvas: canvas,
          chart: geometryData,
          config: state.config,
          style: style,
        );
      } else {
        throw ArgumentError('No State of this type exists!');
      }
    }

    // We will draw axis on top of the painted chart data.
    _drawAxis(canvas, geometryData);
    _drawLabels(labelPainters, canvas, geometryData);
  }

  void _drawGridLines(Canvas canvas, CartesianChartGeometryData geometryData) {
    var border = _gridBorder
      ..color = style.gridStyle!.gridLineColor
      ..strokeWidth = style.gridStyle!.gridLineWidth;

    var tickPaint = _gridTick
      ..color = style.axisStyle!.tickColor
      ..strokeWidth = style.axisStyle!.tickWidth;

    var x = geometryData.graphPolygon.left;
    // create vertical lines
    for (var i = 0; i <= geometryData.unitData.xUnitsCount; i++) {
      var p1 = Offset(x, geometryData.graphPolygon.bottom);
      var p2 = Offset(x, geometryData.graphPolygon.top);
      canvas.drawLine(p1, p2, border);

      // Draw ticks along x-axis
      canvas.drawLine(
        p1,
        Offset(p1.dx, p1.dy + style.axisStyle!.tickLength),
        tickPaint,
      );

      x += geometryData.graphUnitWidth;
    }

    // create horizontal lines
    for (var i = 0; i <= geometryData.unitData.yUnitsCount; i++) {
      var y =
          geometryData.graphPolygon.bottom - geometryData.graphUnitHeight * i;

      var p1 = Offset(geometryData.graphPolygon.left, y);
      var p2 = Offset(geometryData.graphPolygon.right, y);
      canvas.drawLine(p1, p2, border);

      // Draw ticks along y-axis
      canvas.drawLine(
        p1,
        Offset(p1.dx - style.axisStyle!.tickLength, p1.dy),
        tickPaint,
      );
    }
  }

  void _drawAxis(Canvas canvas, CartesianChartGeometryData geometryData) {
    var axisPaint = _axisPaint
      ..color = style.axisStyle!.axisColor
      ..strokeWidth = style.axisStyle!.axisWidth;

    // We will use a L shaped path for the Axes
    var axis = Path();
    axis.moveTo(geometryData.graphPolygon.topLeft.dx,
        geometryData.graphPolygon.topLeft.dy);
    axis.lineTo(
        geometryData.axisOrigin.dx, geometryData.axisOrigin.dy); // +ve y axis
    axis.lineTo(geometryData.graphPolygon.right,
        geometryData.axisOrigin.dy); // +ve x axis

    if (rangeData.minYRange.isNegative) {
      // Paint negative Y-axis if we have negative values
      axis.moveTo(geometryData.graphPolygon.bottomLeft.dx,
          geometryData.graphPolygon.bottomLeft.dy);
      axis.lineTo(
          geometryData.axisOrigin.dx, geometryData.axisOrigin.dy); // -ve y axis
    }

    if (rangeData.minXRange.isNegative) {
      // Paint negative X-axis if we have Negative values
      axis.lineTo(geometryData.graphPolygon.left,
          geometryData.axisOrigin.dy); // -ve x axis
    }

    canvas.drawPath(axis, axisPaint);
  }

  void _drawLabels(_TextPainterLayoutData textLayoutData, Canvas canvas,
      CartesianChartGeometryData geometryData) {
    var x = geometryData.graphPolygon.left;
    if (textLayoutData.showXLabels || true) {
      for (var element in textLayoutData.xLabelPainters) {
        element.paint(
          canvas: canvas,
          offset: Offset(
              x, geometryData.graphPolygon.bottom + _labelPlacementOffset),
        );
        x += geometryData.graphUnitWidth;
      }
    }

    if (textLayoutData.showYLabels) {
      for (var i = 0; i < textLayoutData.yLabelPainters.length; i++) {
        textLayoutData.yLabelPainters[i].paint(
          canvas: canvas,
          offset: Offset(
            geometryData.graphPolygon.left - _labelPlacementOffset,
            geometryData.graphPolygon.bottom - geometryData.graphUnitHeight * i,
          ),
        );
      }
    }
  }

  EdgeInsets _calculateLabelInsets(
      UnitData unitData, _TextPainterLayoutData labelPainters, Size size) {
    final leftInset = labelPainters.maxYLabelWidth + _labelPlacementOffset;
    final width = size.width - leftInset;
    var maxPainterLabelInsets = EdgeInsets.zero;

    for (var i = 0; i < states.length; i++) {
      final state = states[i]
          as PaintingState<CartesianSeries, CartesianConfig, CartesianPainter>;
      final inset = state.painter.performAxisLabelLayout(
        series: state.data,
        style: style,
        graphUnitWidth: width / unitData.xUnitsCount,
        valueUnitWidth: width / unitData.totalXRange,
      );
      maxPainterLabelInsets = maxInsets(maxPainterLabelInsets, inset);
    }

    final graphInsets = EdgeInsets.only(
        left: leftInset,
        // TODO: Calculated based on top label's height / 2
        top: 10,
        right: 0,
        bottom: labelPainters.maxXLabelHeight + _labelPlacementOffset);

    return maxInsets(maxPainterLabelInsets, graphInsets);
  }

  _TextPainterLayoutData _layoutLabels(
    Canvas canvas,
    UnitData unitData,
  ) {
    final maxIterations = max(unitData.xUnitsCount, unitData.yUnitsCount);
    final showXLabels = style.axisStyle?.showXAxisLabels ?? true;
    final showYLabels = style.axisStyle?.showYAxisLabels ?? true;
    final textStyle = style.axisStyle?.tickLabelStyle ?? defaultChartTextStyle;

    final xLabelPainters = <ChartTextPainter>[];
    final yLabelPainters = <ChartTextPainter>[];
    double maxYWidth = 0.0;
    double maxXHeight = 0.0;

    for (var i = 0; i <= maxIterations; i++) {
      // We will plot texts and point along both X & Y axis
      if (showXLabels && i <= unitData.xUnitsCount) {
        final painter = ChartTextPainter.fromChartTextStyle(
          text: i.toPrecision(2).toString(),
          chartTextStyle:
              style.axisStyle?.tickLabelStyle ?? defaultChartTextStyle,
        )..layout();
        maxXHeight = max(maxXHeight, painter.height);
        xLabelPainters.add(painter);
      }

      if (showYLabels && i <= unitData.yUnitsCount) {
        final painter = ChartTextPainter.fromChartTextStyle(
          text: (rangeData.minYRange + (unitData.yUnitValue * i))
              .toPrecision(2)
              .toString(),
          chartTextStyle: textStyle.copyWith(align: TextAlign.end),
        )..layout();
        maxYWidth = max(maxYWidth, painter.width);
        yLabelPainters.add(painter);
      }
    }

    return _TextPainterLayoutData(
      xLabelPainters: xLabelPainters,
      yLabelPainters: yLabelPainters,
      maxXLabelHeight: maxXHeight,
      maxYLabelWidth: maxYWidth,
      showXLabels: showYLabels,
      showYLabels: showYLabels,
    );
  }

  CartesianChartGeometryData _calculateGraphConstraints(
    Size widgetSize,
    EdgeInsets Function(UnitData unitData) layoutAxisLabels,
  ) {
    // TODO: Calculate the effective width & height of the graph
    final graphOrigin = Offset(widgetSize.width * 0.5, widgetSize.height * 0.5);
    final graphWidth = widgetSize.width;
    final graphHeight = widgetSize.height;

    final xUnitValue = style.gridStyle!.xUnitValue!.toDouble();
    final yUnitValue = style.gridStyle!.yUnitValue!.toDouble();

    final totalXRange = rangeData.maxXRange.abs() + rangeData.minXRange.abs();
    final xUnitsCount = totalXRange / xUnitValue;

    final totalYRange = rangeData.maxYRange.abs() + rangeData.minYRange.abs();
    final yUnitsCount = totalYRange / yUnitValue;

    final unitData = UnitData(
        xUnitValue: xUnitValue,
        xUnitsCount: xUnitsCount,
        yUnitValue: yUnitValue,
        yUnitsCount: yUnitsCount,
        totalXRange: totalXRange,
        totalYRange: totalYRange);

    final labelInsets = layoutAxisLabels(unitData);

    final graphPolygon = Rect.fromLTRB(
      labelInsets.left,
      labelInsets.top,
      graphWidth - labelInsets.right,
      graphHeight - labelInsets.bottom,
    );

    // We will get unitWidth & unitHeight by dividing the
    // graphWidth & graphHeight into X parts
    final graphUnitWidth = graphPolygon.width / xUnitsCount;
    final graphUnitHeight = graphPolygon.height / yUnitsCount;

    // Get the unitValue if the data range was within the graph's constraints
    final valueUnitWidth = graphPolygon.width / totalXRange;
    final valueUnitHeight = graphPolygon.height / totalYRange;

    // Calculate the Offset for Axis Origin
    var negativeXRange =
        (rangeData.minXRange.abs() / xUnitValue) * graphUnitWidth;
    var negativeYRange =
        (rangeData.minYRange.abs() / yUnitValue) * graphUnitHeight;
    var xOffset = graphPolygon.left + negativeXRange;
    var yOffset = graphPolygon.bottom - negativeYRange;
    final axisOrigin = Offset(xOffset, yOffset);

    return CartesianChartGeometryData(
        graphPolygon: graphPolygon,
        graphHeight: graphPolygon.height,
        graphWidth: graphPolygon.width,
        graphOrigin: graphOrigin,
        axisOrigin: axisOrigin,
        graphUnitWidth: graphUnitWidth,
        graphUnitHeight: graphUnitHeight,
        valueUnitWidth: valueUnitWidth,
        valueUnitHeight: valueUnitHeight,
        totalXRange: totalXRange,
        totalYRange: totalYRange,
        unitData: unitData,
        graphEdgeInsets: labelInsets);
  }
}

class CartesianChartGeometryData extends Equatable {
  final Rect graphPolygon;
  final double graphHeight;
  final double graphWidth;
  final Offset graphOrigin;
  final Offset axisOrigin;

  final double graphUnitWidth;
  final double graphUnitHeight;

  final double valueUnitWidth;
  final double valueUnitHeight;

  final double totalXRange;
  final double totalYRange;

  final UnitData unitData;
  final EdgeInsets graphEdgeInsets;

  const CartesianChartGeometryData({
    required this.graphPolygon,
    required this.graphHeight,
    required this.graphWidth,
    required this.graphOrigin,
    required this.axisOrigin,
    required this.graphUnitWidth,
    required this.graphUnitHeight,
    required this.valueUnitWidth,
    required this.valueUnitHeight,
    required this.totalXRange,
    required this.totalYRange,
    required this.unitData,
    required this.graphEdgeInsets,
  });

  const CartesianChartGeometryData.zero()
      : graphPolygon = Rect.zero,
        graphHeight = 0,
        graphWidth = 0,
        graphOrigin = Offset.zero,
        axisOrigin = Offset.zero,
        graphUnitWidth = 0,
        graphUnitHeight = 0,
        totalXRange = 0,
        totalYRange = 0,
        valueUnitWidth = 0,
        valueUnitHeight = 0,
        unitData = UnitData.zero,
        graphEdgeInsets = EdgeInsets.zero;

  @override
  List<Object?> get props => [
        graphPolygon,
        graphHeight,
        graphWidth,
        graphOrigin,
        axisOrigin,
        graphUnitWidth,
        graphUnitHeight,
        valueUnitWidth,
        valueUnitHeight,
        totalXRange,
        totalYRange,
        unitData,
        graphEdgeInsets
      ];

  CartesianChartGeometryData copyWith({
    Rect? graphPolygon,
    double? graphHeight,
    double? graphWidth,
    Offset? graphOrigin,
    Offset? axisOrigin,
    double? graphUnitWidth,
    double? graphUnitHeight,
    double? valueUnitWidth,
    double? valueUnitHeight,
    double? totalXRange,
    double? totalYRange,
    UnitData? unitData,
    EdgeInsets? graphEdgeInsets,
  }) {
    return CartesianChartGeometryData(
      graphPolygon: graphPolygon ?? this.graphPolygon,
      graphHeight: graphHeight ?? this.graphHeight,
      graphWidth: graphWidth ?? this.graphWidth,
      graphOrigin: graphOrigin ?? this.graphOrigin,
      axisOrigin: axisOrigin ?? this.axisOrigin,
      graphUnitWidth: graphUnitWidth ?? this.graphUnitWidth,
      graphUnitHeight: graphUnitHeight ?? this.graphUnitHeight,
      valueUnitWidth: valueUnitWidth ?? this.valueUnitWidth,
      valueUnitHeight: valueUnitHeight ?? this.valueUnitHeight,
      totalXRange: totalXRange ?? this.totalXRange,
      totalYRange: totalYRange ?? this.totalYRange,
      unitData: unitData ?? this.unitData,
      graphEdgeInsets: graphEdgeInsets ?? this.graphEdgeInsets,
    );
  }
}

class UnitData extends Equatable {
  final double xUnitValue;
  final double xUnitsCount;
  final double yUnitValue;
  final double yUnitsCount;
  final double totalXRange;
  final double totalYRange;

  const UnitData({
    required this.xUnitValue,
    required this.xUnitsCount,
    required this.yUnitValue,
    required this.yUnitsCount,
    required this.totalXRange,
    required this.totalYRange,
  });

  static const UnitData zero = UnitData(
      xUnitValue: 0.0,
      xUnitsCount: 0.0,
      yUnitValue: 0.0,
      yUnitsCount: 0.0,
      totalXRange: 0.0,
      totalYRange: 0.0);

  @override
  List<Object?> get props => [
        xUnitsCount,
        xUnitValue,
        yUnitsCount,
        yUnitValue,
        totalXRange,
        totalYRange
      ];
}

class _TextPainterLayoutData extends Equatable {
  final List<ChartTextPainter> xLabelPainters;
  final List<ChartTextPainter> yLabelPainters;
  final double maxXLabelHeight;
  final double maxYLabelWidth;
  final bool showXLabels;
  final bool showYLabels;

  const _TextPainterLayoutData({
    required this.xLabelPainters,
    required this.yLabelPainters,
    required this.maxXLabelHeight,
    required this.maxYLabelWidth,
    required this.showXLabels,
    required this.showYLabels,
  });

  @override
  List<Object?> get props => [
        xLabelPainters,
        yLabelPainters,
        maxXLabelHeight,
        maxYLabelWidth,
        showXLabels,
        showYLabels,
      ];
}
