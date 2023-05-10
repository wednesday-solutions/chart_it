import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CartesianScaffoldParentData extends ContainerBoxParentData<RenderBox> {
  CartesianPaintingGeometryData paintingGeometryData =
      CartesianPaintingGeometryData.zero;

  @override
  String toString() {
    return 'CartesianScaffoldParentData{paintingGeometryData: $paintingGeometryData}';
  }
}

enum ChartScaffoldSlot { center, left, bottom, right, top }

class CartesianScaffold extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<ChartScaffoldSlot> {
  final Widget Function()? leftLabel;
  final Widget Function()? rightLabel;
  final Widget Function()? topLabel;
  final Widget Function()? bottomLabel;
  final Widget chart;
  final GridUnitsData gridUnitsData;
  final CartesianChartStylingData stylingData;

  const CartesianScaffold({
    this.leftLabel,
    this.rightLabel,
    this.topLabel,
    this.bottomLabel,
    required this.chart,
    super.key,
    required this.gridUnitsData,
    required this.stylingData,
  });

  @override
  Widget? childForSlot(ChartScaffoldSlot slot) {
    switch (slot) {
      case ChartScaffoldSlot.left:
        return Column(
          children: [
            Text("${gridUnitsData.xUnitValue} asdfasdfklsjfdaklsjf;safjas;"),
            const Text("20")
          ],
        );
      case ChartScaffoldSlot.right:
        break;
      case ChartScaffoldSlot.top:
        break;
      case ChartScaffoldSlot.bottom:
        return Row(
          children: [
            Text("${gridUnitsData.xUnitValue} asdfasdfklsjfdaklsjf;safjas;"),
            const Text("20")
          ],
        );
      case ChartScaffoldSlot.center:
        return chart;
    }
    return null;
  }

  @override
  SlottedContainerRenderObjectMixin<ChartScaffoldSlot> createRenderObject(
      BuildContext context) {
    return RenderCartesianScaffold(
      gridUnitsData: gridUnitsData,
      stylingData: stylingData,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCartesianScaffold renderObject) {
    renderObject
      ..gridUnitsData = gridUnitsData
      ..stylingData = stylingData;
  }

  @override
  Iterable<ChartScaffoldSlot> get slots => ChartScaffoldSlot.values;
}

class RenderCartesianScaffold extends RenderBox
    with SlottedContainerRenderObjectMixin<ChartScaffoldSlot> {
  GridUnitsData _gridUnitsData;

  set gridUnitsData(GridUnitsData value) {
    if (_gridUnitsData == value) return;
    _gridUnitsData = value;
    markNeedsPaint();
  }

  CartesianChartStylingData _stylingData;

  set stylingData(CartesianChartStylingData value) {
    if (_stylingData == value) return;
    _stylingData = value;
    markNeedsPaint();
  }

  final Paint _bgPaint;
  final Paint _gridBorder;
  final Paint _gridTick;
  final Paint _axisPaint;

  RenderCartesianScaffold({
    required GridUnitsData gridUnitsData,
    required CartesianChartStylingData stylingData,
  })  : _gridUnitsData = gridUnitsData,
        _stylingData = stylingData,
        _bgPaint = Paint(),
        _gridBorder = Paint()..style = PaintingStyle.stroke,
        _gridTick = Paint()..style = PaintingStyle.stroke,
        _axisPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CartesianScaffoldParentData) {
      child.parentData = CartesianScaffoldParentData();
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    Size leftSize = Size.zero;
    Size rightSize = Size.zero;
    Size topSize = Size.zero;
    Size bottomSize = Size.zero;

    // TODO: Get from properties
    final maxWidth = min(constraints.maxWidth, double.infinity);
    final maxHeight = min(constraints.maxHeight, 400.0);
    final leftWidthPercentage = 0.1;
    final rightWidthPercentage = 0.1;
    final topHeightPercentage = 0.1;
    final bottomHeightPercentage = 0.1;

    RenderBox? renderBox = childForSlot(ChartScaffoldSlot.left);

    if (renderBox != null) {
      renderBox.layout(
        BoxConstraints(
          maxWidth: maxWidth * leftWidthPercentage,
          maxHeight: maxHeight,
        ),
        parentUsesSize: true,
      );

      (renderBox.parentData as CartesianScaffoldParentData).offset =
          Offset.zero;

      leftSize = renderBox.size;
    }

    renderBox = childForSlot(ChartScaffoldSlot.bottom);

    if (renderBox != null) {
      renderBox.layout(
        BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight * bottomHeightPercentage,
        ),
        parentUsesSize: true,
      );

      (renderBox.parentData as CartesianScaffoldParentData).offset = Offset(
        0,
        maxHeight - renderBox.size.height,
      );

      bottomSize = renderBox.size;
    }

    renderBox = childForSlot(ChartScaffoldSlot.right);

    if (renderBox != null) {
      renderBox.layout(
        BoxConstraints(
          maxWidth: maxWidth * rightWidthPercentage,
          maxHeight: maxHeight,
        ),
        parentUsesSize: true,
      );

      (renderBox.parentData as CartesianScaffoldParentData).offset = Offset(
        maxWidth - renderBox.size.width,
        0,
      );

      rightSize = renderBox.size;
    }

    renderBox = childForSlot(ChartScaffoldSlot.top);

    if (renderBox != null) {
      renderBox.layout(
        BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight * topHeightPercentage,
        ),
        parentUsesSize: true,
      );

      (renderBox.parentData as CartesianScaffoldParentData).offset =
          Offset.zero;

      topSize = renderBox.size;
    }

    assert(childForSlot(ChartScaffoldSlot.center) != null);
    renderBox = childForSlot(ChartScaffoldSlot.center)!;

    final chartConstraints = BoxConstraints(
      maxWidth: maxWidth - leftSize.width - rightSize.width,
      maxHeight: maxHeight - bottomSize.height - topSize.height,
    );

    renderBox.layout(chartConstraints, parentUsesSize: true);

    (renderBox.parentData as CartesianScaffoldParentData).offset = Offset(
      leftSize.width,
      topSize.height,
    );

    return constraints.constrain(Size(maxWidth, maxHeight));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData =
          child.parentData! as CartesianScaffoldParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final chartRenderBox = childForSlot(ChartScaffoldSlot.center)!;
    final chartParentData =
        chartRenderBox.parentData as CartesianScaffoldParentData;

    final geometryData = _calculateGraphConstraints(
      chartRenderBox.size,
      chartParentData.offset,
      _gridUnitsData,
    );

    if (_stylingData.gridStyle?.show == true) {
      _drawGridLines(context.canvas, geometryData);
    }

    RenderBox? renderBox = childForSlot(ChartScaffoldSlot.left);
    if (renderBox != null) {
      _paintChild(
        renderBox: renderBox,
        geometryData: geometryData,
        context: context,
      );
    }

    renderBox = childForSlot(ChartScaffoldSlot.bottom);
    if (renderBox != null) {
      _paintChild(
        renderBox: renderBox,
        geometryData: geometryData,
        context: context,
      );
    }

    renderBox = childForSlot(ChartScaffoldSlot.right);
    if (renderBox != null) {
      _paintChild(
        renderBox: renderBox,
        geometryData: geometryData,
        context: context,
      );
    }

    renderBox = childForSlot(ChartScaffoldSlot.top);
    if (renderBox != null) {
      _paintChild(
        renderBox: renderBox,
        geometryData: geometryData,
        context: context,
      );
    }

    chartParentData.paintingGeometryData = geometryData;
    context.paintChild(chartRenderBox, chartParentData.offset);

    // We will draw axis on top of the painted chart data.
    _drawAxis(context.canvas, geometryData);
  }

  void _paintChild({
    required RenderBox renderBox,
    required CartesianPaintingGeometryData geometryData,
    required PaintingContext context,
  }) {
    CartesianScaffoldParentData childParentData =
        renderBox.parentData as CartesianScaffoldParentData;
    childParentData.paintingGeometryData = geometryData;
    context.paintChild(renderBox, childParentData.offset);
  }

  void _drawGridLines(
      Canvas canvas, CartesianPaintingGeometryData geometryData) {
    var border = _gridBorder
      ..color = _stylingData.gridStyle!.gridLineColor
      ..strokeWidth = _stylingData.gridStyle!.gridLineWidth;

    var tickPaint = _gridTick
      ..color = _stylingData.axisStyle!.tickColor
      ..strokeWidth = _stylingData.axisStyle!.tickWidth;

    var x = geometryData.graphPolygon.left;
    // create vertical lines
    for (var i = 0; i <= geometryData.unitData.xUnitsCount; i++) {
      var p1 = Offset(x, geometryData.graphPolygon.bottom);
      var p2 = Offset(x, geometryData.graphPolygon.top);
      canvas.drawLine(p1, p2, border);

      // Draw ticks along x-axis
      canvas.drawLine(
        p1,
        Offset(p1.dx, p1.dy + _stylingData.axisStyle!.tickLength),
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
        Offset(p1.dx - _stylingData.axisStyle!.tickLength, p1.dy),
        tickPaint,
      );
    }
  }

  void _drawAxis(Canvas canvas, CartesianPaintingGeometryData geometryData) {
    var axisPaint = _axisPaint
      ..color = _stylingData.axisStyle!.axisColor
      ..strokeWidth = _stylingData.axisStyle!.axisWidth;

    // We will use a L shaped path for the Axes
    var axis = Path();
    axis.moveTo(geometryData.graphPolygon.topLeft.dx,
        geometryData.graphPolygon.topLeft.dy);
    axis.lineTo(
        geometryData.axisOrigin.dx, geometryData.axisOrigin.dy); // +ve y axis
    axis.lineTo(geometryData.graphPolygon.right,
        geometryData.axisOrigin.dy); // +ve x axis

    if (_gridUnitsData.minYRange.isNegative) {
      // Paint negative Y-axis if we have negative values
      axis.moveTo(geometryData.graphPolygon.bottomLeft.dx,
          geometryData.graphPolygon.bottomLeft.dy);
      axis.lineTo(
          geometryData.axisOrigin.dx, geometryData.axisOrigin.dy); // -ve y axis
    }

    if (_gridUnitsData.minXRange.isNegative) {
      // Paint negative X-axis if we have Negative values
      axis.lineTo(geometryData.graphPolygon.left,
          geometryData.axisOrigin.dy); // -ve x axis
    }

    canvas.drawPath(axis, axisPaint);
  }

  CartesianPaintingGeometryData _calculateGraphConstraints(
    Size widgetSize,
    Offset origin,
    GridUnitsData gridUnitsData,
  ) {
    // TODO: Calculate the effective width & height of the graph
    final xUnitValue = gridUnitsData.xUnitValue.toDouble();
    final yUnitValue = gridUnitsData.yUnitValue.toDouble();

    final graphPolygon = origin & widgetSize;

    // We will get unitWidth & unitHeight by dividing the
    // graphWidth & graphHeight into X parts
    final graphUnitWidth = graphPolygon.width / gridUnitsData.xUnitsCount;
    final graphUnitHeight = graphPolygon.height / gridUnitsData.yUnitsCount;

    // Get the unitValue if the data range was within the graph's constraints
    final valueUnitWidth = graphPolygon.width / gridUnitsData.totalXRange;
    final valueUnitHeight = graphPolygon.height / gridUnitsData.totalYRange;

    // Calculate the Offset for Axis Origin
    var negativeXRange =
        (_gridUnitsData.minXRange.abs() / xUnitValue) * graphUnitWidth;
    var negativeYRange =
        (_gridUnitsData.minYRange.abs() / yUnitValue) * graphUnitHeight;
    var xOffset = graphPolygon.left + negativeXRange;
    var yOffset = graphPolygon.bottom - negativeYRange;
    final axisOrigin = Offset(xOffset, yOffset);

    return CartesianPaintingGeometryData(
      graphPolygon: graphPolygon,
      axisOrigin: axisOrigin,
      graphUnitWidth: graphUnitWidth,
      graphUnitHeight: graphUnitHeight,
      valueUnitWidth: valueUnitWidth,
      valueUnitHeight: valueUnitHeight,
      unitData: gridUnitsData,
      xUnitValue: xUnitValue,
    );
  }
}
