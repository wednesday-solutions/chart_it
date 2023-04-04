import 'dart:developer';
import 'dart:math';

import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_mixins.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_styling.dart';
import 'package:chart_it/src/charts/data/core/shared/chart_text_style.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/charts/painters/text/chart_text_painter.dart';
import 'package:flutter/material.dart';

mixin InteractionDispatcher {
  Offset? _latestDoubleTapOffset;
  Offset? _latestPanOffset;

  @protected
  void onInteraction(
      ChartInteractionType interactionType, Offset localPosition);

  void onTapUp(Offset localPosition) {
    onInteraction(ChartInteractionType.tap, localPosition);
  }

  void onDoubleTapDown(Offset localPosition) {
    _latestDoubleTapOffset = localPosition;
  }

  void onDoubleTapCancel() {
    _latestDoubleTapOffset = null;
  }

  void onDoubleTap() {
    final latestDoubleTapOffset = _latestDoubleTapOffset;
    if (latestDoubleTapOffset != null) {
      onInteraction(ChartInteractionType.doubleTap, latestDoubleTapOffset);
    }
  }

  void onPanStart(Offset localPosition) {
    _latestPanOffset = localPosition;
    onInteraction(ChartInteractionType.drag, localPosition);
  }

  void onPanUpdate(Offset localPosition) {
    _latestPanOffset = localPosition;
    onInteraction(ChartInteractionType.drag, localPosition);
  }

  void onPanCancel() {
    _latestPanOffset = null;
  }

  void onPanEnd() {
    final latestPanOffset = _latestPanOffset;
    if (latestPanOffset != null) {
      onInteraction(ChartInteractionType.dragEnd, latestPanOffset);
    }
    _latestPanOffset = null;
  }
}

enum ChartInteractionType {
  tap,
  doubleTap,
  dragStart,
  drag,
  dragEnd;
}

abstract class ChartInteractionResult {
  final Offset? localPosition;
  final ChartInteractionType interactionType;

  ChartInteractionResult({
    required this.localPosition,
    required this.interactionType,
  });
}

abstract class ChartInteractionConfig<T extends ChartInteractionResult> {
  final bool isEnabled;
  final void Function(T interactionResult)? onRawInteraction;
  final void Function(T interactionResult)? onTap;
  final void Function(T interactionResult)? onDoubleTap;
  final void Function(T interactionResult)? onDragStart;
  final void Function(T interactionResult)? onDrag;
  final void Function(T interactionResult)? onDragEnd;

  const ChartInteractionConfig({
    this.onRawInteraction,
    required this.onTap,
    required this.onDoubleTap,
    required this.onDragStart,
    required this.onDrag,
    required this.onDragEnd,
    required this.isEnabled,
  });

  void onInteraction(T interactionResult) {
    switch (interactionResult.interactionType) {
      case ChartInteractionType.tap:
        onTap?.call(interactionResult);
        break;
      case ChartInteractionType.doubleTap:
        onDoubleTap?.call(interactionResult);
        break;
      case ChartInteractionType.drag:
        onDragStart?.call(interactionResult);
        break;
      case ChartInteractionType.dragStart:
        onDrag?.call(interactionResult);
        break;
      case ChartInteractionType.dragEnd:
        onDragEnd?.call(interactionResult);
        break;
    }
  }

  bool get shouldHitTest =>
      isEnabled &&
      (onRawInteraction != null ||
          onTap != null ||
          onDoubleTap != null ||
          onDragStart != null ||
          onDragEnd != null ||
          onDrag != null);
}

class CartesianChartPainter {
  late Rect graphPolygon;
  late double graphHeight;
  late double graphWidth;
  late Offset graphOrigin;
  late Offset axisOrigin;

  late double graphUnitWidth;
  late double graphUnitHeight;

  late double valueUnitWidth;
  late double valueUnitHeight;

  late double xUnitValue;
  late double _xUnitsCount;
  late double totalXRange;

  late double yUnitValue;
  late double _yUnitsCount;
  late double totalYRange;

  CartesianChartStyle style;
  List<CartesianSeries> currentData;
  List<CartesianSeries> targetData;
  Map<int, CartesianPainter> painters;
  Map<CartesianSeries, CartesianConfig> configs;
  CartesianDataMixin rangeData;

  CartesianChartPainter({
    required this.style,
    required this.currentData,
    required this.targetData,
    required this.painters,
    required this.configs,
    required this.rangeData,
  });

  void paint(Canvas canvas, Size size) {
    // Calculate constraints for the graph
    _calculateGraphConstraints(size);

    Timeline.startSync('Painting Background');
    // Paint the background
    var bg = Paint()..color = style.backgroundColor;
    canvas.drawPaint(bg);
    Timeline.finishSync();

    _drawGridLines(canvas, size);

    Timeline.startSync('Looping Painters');
    // Finally for every data series, we will construct a painter and handover
    // the canvas to them to draw the data sets into the required chart
    for (var i = 0; i < targetData.length; i++) {
      final target = targetData[i];
      var painter = painters[i];
      var config = configs[target];
      if (painter != null && config != null) {
        painter.paint(
          currentData[i],
          target,
          canvas,
          this,
          config,
        );
      }
    }
    Timeline.finishSync();

    // controller.targetData.forEachIndexed((index, series) {
    //   // get the painter for this data
    //   var painter = controller.painters[series.runtimeType];
    //   if (painter != null) {
    //     // and paint the chart for given series
    //     painter.paint(controller.currentData[index], series, canvas, this);
    //   } else {
    //     throw ArgumentError(
    //       'Illegal State: No painter found for series type: ${series.runtimeType}',
    //     );
    //   }
    // });

    // We will draw axis on top of the painted chart data.
    _drawAxis(canvas, size);
  }

  void _drawGridLines(Canvas canvas, Size size) {
    Timeline.startSync('Painting Grids');
    var border = Paint()
      ..color = style.gridStyle!.gridLineColor
      ..strokeWidth = style.gridStyle!.gridLineWidth
      ..style = PaintingStyle.stroke;

    var tickPaint = Paint()
      ..color = style.axisStyle!.tickColor
      ..strokeWidth = style.axisStyle!.tickWidth
      ..style = PaintingStyle.stroke;

    Timeline.startSync('Vertical Lines');
    var x = graphPolygon.left;
    // create vertical lines
    for (var i = 0; i <= _xUnitsCount; i++) {
      var p1 = Offset(x, graphPolygon.bottom);
      var p2 = Offset(x, graphPolygon.top);
      canvas.drawLine(p1, p2, border);

      // Draw ticks along x-axis
      canvas.drawLine(
        p1,
        Offset(p1.dx, p1.dy + style.axisStyle!.tickLength),
        tickPaint,
      );

      x += graphUnitWidth;
    }
    Timeline.finishSync();

    Timeline.startSync('Horizontal Lines');
    // create horizontal lines
    for (var i = 0; i <= _yUnitsCount; i++) {
      var y = graphPolygon.bottom - graphUnitHeight * i;

      var p1 = Offset(graphPolygon.left, y);
      var p2 = Offset(graphPolygon.right, y);
      canvas.drawLine(p1, p2, border);

      // Draw ticks along y-axis
      canvas.drawLine(
        p1,
        Offset(p1.dx - style.axisStyle!.tickLength, p1.dy),
        tickPaint,
      );
    }
    Timeline.finishSync();

    Timeline.finishSync();
  }

  void _drawAxis(Canvas canvas, Size size) {
    Timeline.startSync('Painting Axis');
    var axisPaint = Paint()
      ..color = style.axisStyle!.axisColor
      ..strokeWidth = style.axisStyle!.axisWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // We will use a L shaped path for the Axes
    var axis = Path();
    axis.moveTo(graphPolygon.topLeft.dx, graphPolygon.topLeft.dy);
    axis.lineTo(axisOrigin.dx, axisOrigin.dy); // +ve y axis
    axis.lineTo(graphPolygon.right, axisOrigin.dy); // +ve x axis

    if (rangeData.minYRange.isNegative) {
      // Paint negative Y-axis if we have negative values
      axis.moveTo(graphPolygon.bottomLeft.dx, graphPolygon.bottomLeft.dy);
      axis.lineTo(axisOrigin.dx, axisOrigin.dy); // -ve y axis
    }

    if (rangeData.minXRange.isNegative) {
      // Paint negative X-axis if we have Negative values
      axis.lineTo(graphPolygon.left, axisOrigin.dy); // -ve x axis
    }

    canvas.drawPath(axis, axisPaint);
    drawLabels(canvas);
    Timeline.finishSync();
  }

  void drawLabels(Canvas canvas) {
    var x = graphPolygon.left;
    var maxIterations = max(_xUnitsCount, _yUnitsCount);
    var showXLabels = style.axisStyle?.showXAxisLabels ?? true;
    var showYLabels = style.axisStyle?.showYAxisLabels ?? true;

    for (var i = 0; i <= maxIterations; i++) {
      Timeline.startSync('X-Axis Labels');
      // We will plot texts and point along both X & Y axis
      if (showXLabels && i <= _xUnitsCount) {
        ChartTextPainter.fromChartTextStyle(
          text: i.toString(),
          chartTextStyle:
              style.axisStyle?.tickLabelStyle ?? const ChartTextStyle(),
        ).paint(
          canvas: canvas,
          offset:
              Offset(x, graphPolygon.bottom + style.axisStyle!.tickLength + 15),
        );

        // increment by unitWidth every iteration along x
        x += graphUnitWidth;
      }
      Timeline.finishSync();

      Timeline.startSync('Y-Axis Labels');
      if (showYLabels && i <= _yUnitsCount) {
        final textStyle =
            style.axisStyle?.tickLabelStyle ?? const ChartTextStyle();
        ChartTextPainter.fromChartTextStyle(
          text: (rangeData.minYRange + (yUnitValue * i)).toString(),
          chartTextStyle: textStyle.copyWith(align: TextAlign.end),
        ).paint(
          canvas: canvas,
          offset: Offset(
            graphPolygon.left - style.axisStyle!.tickLength - 15,
            graphPolygon.bottom - graphUnitHeight * i,
          ),
        );
      }
      Timeline.finishSync();
    }
  }

  _calculateGraphConstraints(Size widgetSize) {
    Timeline.startSync('Graph Constraints');
    // TODO: Calculate the effective width & height of the graph
    graphOrigin = Offset(widgetSize.width * 0.5, widgetSize.height * 0.5);
    graphWidth = widgetSize.width * 0.8;
    graphHeight = widgetSize.height * 0.8;

    graphPolygon = Rect.fromCenter(
      center: graphOrigin,
      width: graphWidth,
      height: graphHeight,
    );

    xUnitValue = style.gridStyle!.xUnitValue!.toDouble();
    yUnitValue = style.gridStyle!.yUnitValue!.toDouble();

    totalXRange = rangeData.maxXRange.abs() + rangeData.minXRange.abs();
    _xUnitsCount = totalXRange / xUnitValue;

    totalYRange = rangeData.maxYRange.abs() + rangeData.minYRange.abs();
    _yUnitsCount = totalYRange / yUnitValue;

    // We will get unitWidth & unitHeight by dividing the
    // graphWidth & graphHeight into X parts
    graphUnitWidth = graphWidth / _xUnitsCount;
    graphUnitHeight = graphHeight / _yUnitsCount;

    // Get the unitValue if the data range was within the graph's constraints
    valueUnitWidth = graphWidth / totalXRange;
    valueUnitHeight = graphHeight / totalYRange;

    // Calculate the Offset for Axis Origin
    var negativeXRange =
        (rangeData.minXRange.abs() / xUnitValue) * graphUnitWidth;
    var negativeYRange =
        (rangeData.minYRange.abs() / yUnitValue) * graphUnitHeight;
    var xOffset = graphPolygon.left + negativeXRange;
    var yOffset = graphPolygon.bottom - negativeYRange;
    axisOrigin = Offset(xOffset, yOffset);
    Timeline.finishSync();
  }
}
