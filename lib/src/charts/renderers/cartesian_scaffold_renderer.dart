import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/renderers/axis_labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CartesianScaffoldParentData extends ContainerBoxParentData<RenderBox> {
  CartesianPaintingGeometryData paintingGeometryData =
      CartesianPaintingGeometryData.zero;

  @override
  String toString() {
    return 'CartesianScaffoldParentData{paintingGeometryData: $paintingGeometryData}';
  }
}

enum ChartScaffoldSlot { center, left, bottom, right, top }

typedef LabelBuilder = Widget Function(int index, double value);

class CartesianScaffold extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<ChartScaffoldSlot> {
  final LabelBuilder? leftLabel;
  final LabelBuilder? rightLabel;
  final LabelBuilder? topLabel;
  final LabelBuilder? bottomLabel;
  final Widget chart;
  final GridUnitsData gridUnitsData;
  final CartesianChartStylingData stylingData;
  final double? width;
  final double? height;

  const CartesianScaffold({
    this.leftLabel,
    this.rightLabel,
    this.topLabel,
    this.bottomLabel,
    required this.chart,
    super.key,
    required this.gridUnitsData,
    required this.stylingData,
    this.width,
    this.height,
  });

  @override
  Widget? childForSlot(ChartScaffoldSlot slot) {
    switch (slot) {
      case ChartScaffoldSlot.left:
        if (leftLabel != null) {
          return AxisLabelsRenderer(
            gridUnitsData: gridUnitsData,
            orientation: AxisOrientation.vertical,
            labelBuilder: leftLabel!,
          );
        }
        break;
      case ChartScaffoldSlot.right:
        if (rightLabel != null) {
          return AxisLabelsRenderer(
            gridUnitsData: gridUnitsData,
            orientation: AxisOrientation.vertical,
            constraintEdgeLabels: true,
            labelBuilder: rightLabel!,
          );
        }
        break;
      case ChartScaffoldSlot.top:
        if (topLabel != null) {
          return AxisLabelsRenderer(
            gridUnitsData: gridUnitsData,
            orientation: AxisOrientation.horizontal,
            labelBuilder: topLabel!,
          );
        }
        break;
      case ChartScaffoldSlot.bottom:
        if (bottomLabel != null) {
          return AxisLabelsRenderer(
            gridUnitsData: gridUnitsData,
            orientation: AxisOrientation.horizontal,
            centerLabels: true,
            labelBuilder: bottomLabel!,
          );
        }
        break;
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
      width: width,
      height: height,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCartesianScaffold renderObject) {
    renderObject
      ..gridUnitsData = gridUnitsData
      ..stylingData = stylingData
      ..width = width
      ..height = height;
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
    markNeedsLayout();
  }

  CartesianChartStylingData _stylingData;

  set stylingData(CartesianChartStylingData value) {
    if (_stylingData == value) return;
    _stylingData = value;
    markNeedsPaint();
  }

  double? _width;

  set width(double? value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  double? _height;

  set height(double? value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  final Paint _bgPaint;
  final Paint _gridBorder;
  final Paint _gridTick;
  final Paint _axisPaint;

  RenderCartesianScaffold(
      {required GridUnitsData gridUnitsData,
      required CartesianChartStylingData stylingData,
      double? width,
      double? height})
      : _gridUnitsData = gridUnitsData,
        _stylingData = stylingData,
        _width = width,
        _height = height,
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
    size = _performLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _performLayout(constraints, dry: true);
  }

  Size _performLayout(BoxConstraints constraints, {bool dry = false}) {
    // TODO: Get from properties
    final maxWidth = min(constraints.maxWidth, _width ?? double.maxFinite);
    final maxHeight = min(constraints.maxHeight, _height ?? double.maxFinite);

    final bottom = childForSlot(ChartScaffoldSlot.bottom);
    final top = childForSlot(ChartScaffoldSlot.top);
    final left = childForSlot(ChartScaffoldSlot.left);
    final right = childForSlot(ChartScaffoldSlot.right);

    double bottomIntrinsicHeight =
        bottom?.getMinIntrinsicHeight(constraints.maxWidth) ?? 0.0;
    double leftIntrinsicWidth =
        left?.getMinIntrinsicWidth(constraints.maxHeight) ?? 0.0;
    double rightIntrinsicWidth =
        right?.getMinIntrinsicWidth(constraints.maxHeight) ?? 0.0;
    double topIntrinsicHeight =
        top?.getMinIntrinsicHeight(constraints.maxHeight) ?? 0.0;

    final tickConfig = _stylingData.axisStyle?.tickConfig;
    if (tickConfig != null) {
      if (tickConfig.showTickOnLeftAxis) {
        leftIntrinsicWidth += tickConfig.tickLength;
      }
      if (tickConfig.showTickOnBottomAxis) {
        bottomIntrinsicHeight += tickConfig.tickLength;
      }
      if (tickConfig.showTickOnRightAxis) {
        rightIntrinsicWidth += tickConfig.tickLength;
      }
      if (tickConfig.showTickOnTopAxis) {
        topIntrinsicHeight += tickConfig.tickLength;
      }
    }

    final chartConstraints = BoxConstraints(
      maxWidth: maxWidth - leftIntrinsicWidth - rightIntrinsicWidth,
      maxHeight: maxHeight - bottomIntrinsicHeight - topIntrinsicHeight,
    );

    final paintingGeometryData = _calculatePaintingGeometryData(
      Size(chartConstraints.maxWidth, chartConstraints.maxHeight),
      Offset(leftIntrinsicWidth, topIntrinsicHeight),
      _gridUnitsData,
    );

    RenderBox? renderBox = childForSlot(ChartScaffoldSlot.left);
    if (renderBox != null) {
      _layoutRenderBox(
        renderBox: renderBox,
        constraints: BoxConstraints(
          maxWidth: leftIntrinsicWidth,
          maxHeight: maxHeight - (bottomIntrinsicHeight + topIntrinsicHeight),
        ),
      );

      if (!dry) {
        _positionRenderBox(
          renderBox: renderBox,
          offset: Offset(0, topIntrinsicHeight),
          paintingGeometryData: paintingGeometryData,
        );
      }
    }

    renderBox = childForSlot(ChartScaffoldSlot.bottom);

    if (renderBox != null) {
      _layoutRenderBox(
        renderBox: renderBox,
        constraints: BoxConstraints(
          maxWidth: maxWidth - (leftIntrinsicWidth + rightIntrinsicWidth),
          maxHeight: bottomIntrinsicHeight,
        ),
      );

      if (!dry) {
        _positionRenderBox(
          renderBox: renderBox,
          offset: Offset(
            leftIntrinsicWidth,
            maxHeight - (renderBox.size.height / 2),
          ),
          paintingGeometryData: paintingGeometryData,
        );
      }
    }

    renderBox = childForSlot(ChartScaffoldSlot.right);

    if (renderBox != null) {
      _layoutRenderBox(
        renderBox: renderBox,
        constraints: BoxConstraints(
          maxWidth: rightIntrinsicWidth,
          maxHeight: maxHeight - (bottomIntrinsicHeight + topIntrinsicHeight),
        ),
      );

      if (!dry) {
        final tickOffset = tickConfig?.showTickOnRightAxis == true
            ? tickConfig!.tickLength
            : 0.0;
        _positionRenderBox(
          renderBox: renderBox,
          offset: Offset(
            maxWidth - renderBox.size.width + tickOffset,
            topIntrinsicHeight,
          ),
          paintingGeometryData: paintingGeometryData,
        );
      }
    }

    renderBox = childForSlot(ChartScaffoldSlot.top);

    if (renderBox != null) {
      _layoutRenderBox(
        renderBox: renderBox,
        constraints: BoxConstraints(
          maxWidth: maxWidth - (leftIntrinsicWidth + rightIntrinsicWidth),
          maxHeight: topIntrinsicHeight,
        ),
      );

      if (!dry) {
        _positionRenderBox(
          renderBox: renderBox,
          offset: Offset(leftIntrinsicWidth, 0),
          paintingGeometryData: paintingGeometryData,
        );
      }
    }

    assert(childForSlot(ChartScaffoldSlot.center) != null);
    renderBox = childForSlot(ChartScaffoldSlot.center)!;

    _layoutRenderBox(
      renderBox: renderBox,
      constraints: chartConstraints,
    );

    if (!dry) {
      _positionRenderBox(
        renderBox: renderBox,
        offset: Offset(leftIntrinsicWidth, 0),
        paintingGeometryData: paintingGeometryData,
      );
    }

    return Size(maxWidth, maxHeight);
  }

  Size _layoutRenderBox({
    required RenderBox renderBox,
    required BoxConstraints constraints,
  }) {
    renderBox.layout(
      constraints,
      parentUsesSize: true,
    );

    return renderBox.size;
  }

  _positionRenderBox(
      {required RenderBox renderBox,
      required Offset offset,
      required CartesianPaintingGeometryData paintingGeometryData}) {
    final parentData = renderBox.parentData as CartesianScaffoldParentData;
    parentData.offset = offset;
    parentData.paintingGeometryData = paintingGeometryData;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final chartRenderBox = childForSlot(ChartScaffoldSlot.center)!;
    final chartParentData =
        chartRenderBox.parentData as CartesianScaffoldParentData;

    if (_stylingData.backgroundColor != null) {
      context.canvas
        ..save()
        ..clipRect(offset & size);
      context.canvas.drawPaint(_bgPaint..color = _stylingData.backgroundColor!);
      context.canvas.restore();
    }

    if (_stylingData.gridStyle?.show == true) {
      _drawGrid(context.canvas, chartParentData.paintingGeometryData);
    }

    RenderBox? renderBox = childForSlot(ChartScaffoldSlot.left);
    if (renderBox != null) {
      _paintChild(
        renderBox: renderBox,
        context: context,
      );
    }

    renderBox = childForSlot(ChartScaffoldSlot.bottom);
    if (renderBox != null) {
      _paintChild(
        renderBox: renderBox,
        context: context,
      );
    }

    renderBox = childForSlot(ChartScaffoldSlot.right);
    if (renderBox != null) {
      _paintChild(
        renderBox: renderBox,
        context: context,
      );
    }

    renderBox = childForSlot(ChartScaffoldSlot.top);
    if (renderBox != null) {
      _paintChild(
        renderBox: renderBox,
        context: context,
      );
    }

    context.paintChild(chartRenderBox, chartParentData.offset);

    // We will draw axis on top of the painted chart data.
    _drawAxis(context.canvas, chartParentData.paintingGeometryData);
  }

  void _paintChild({
    required RenderBox renderBox,
    required PaintingContext context,
  }) {
    CartesianScaffoldParentData childParentData =
        renderBox.parentData as CartesianScaffoldParentData;
    context.paintChild(renderBox, childParentData.offset);
  }

  void _drawGrid(Canvas canvas, CartesianPaintingGeometryData geometryData) {
    var border = _gridBorder
      ..color = _stylingData.gridStyle!.gridLineColor
      ..strokeWidth = _stylingData.gridStyle!.gridLineWidth;

    var tickColor = _stylingData.axisStyle?.tickConfig.tickColor;
    if (tickColor != null) {
      _gridTick.color = tickColor;
    }
    var tickWidth = _stylingData.axisStyle?.tickConfig.tickWidth;
    if (tickWidth != null) {
      _gridTick.strokeWidth = tickWidth;
    }

    var x = geometryData.graphPolygon.left;
    // create vertical lines
    for (var i = 0; i <= geometryData.unitData.xUnitsCount; i++) {
      var p1 = Offset(x, geometryData.graphPolygon.bottom);
      var p2 = Offset(x, geometryData.graphPolygon.top);
      canvas.drawLine(p1, p2, border);

      // Draw ticks along x-axis
      final tickConfig = _stylingData.axisStyle?.tickConfig;

      if (tickConfig != null) {
        if (tickConfig.showTickOnBottomAxis) {
          canvas.drawLine(
            p1,
            Offset(p1.dx, p1.dy + tickConfig.tickLength),
            _gridTick,
          );
        }

        if (tickConfig.showTickOnTopAxis) {
          canvas.drawLine(
            p1,
            Offset(p2.dx, p2.dy - tickConfig.tickLength),
            _gridTick,
          );
        }
      }

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
      final tickConfig = _stylingData.axisStyle?.tickConfig;

      if (tickConfig != null) {
        if (tickConfig.showTickOnLeftAxis) {
          canvas.drawLine(
            p1,
            Offset(p1.dx - tickConfig.tickLength, p1.dy),
            _gridTick,
          );
        }

        if (tickConfig.showTickOnRightAxis) {
          canvas.drawLine(
            p1,
            Offset(p2.dx + tickConfig.tickLength, p1.dy),
            _gridTick,
          );
        }
      }
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

  CartesianPaintingGeometryData _calculatePaintingGeometryData(
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
}
