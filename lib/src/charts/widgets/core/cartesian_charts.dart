import 'package:chart_it/src/charts/data/core/cartesian/cartesian_styling.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/controllers/cartesian_controller.dart';
import 'package:flutter/material.dart';

class CartesianCharts extends LeafRenderObjectWidget {
  final double? width;
  final double? height;

  final double? uMinXValue;
  final double? uMaxXValue;
  final double? uMinYValue;
  final double? uMaxYValue;

  // Mandatory Fields
  final CartesianChartStyle style;
  final CartesianController controller;

  const CartesianCharts({
    Key? key,
    this.width,
    this.height,
    this.uMinXValue,
    this.uMaxXValue,
    this.uMinYValue,
    this.uMaxYValue,
    required this.style,
    required this.controller,
  }) : super(key: key);

  // @override
  // State<CartesianCharts> createState() => _CartesianChartsState();

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CartesianChartsState(style: style, controller: controller)
      ..width = width
      ..height = height
      ..uMaxXValue = uMaxXValue
      ..uMaxYValue = uMaxYValue
      ..uMinXValue = uMinXValue
      ..uMinYValue = uMinYValue;
  }
}

class _CartesianChartsState extends RenderBox {
  double? width;
  double? height;

  final CartesianChartPainter _painter;

  set uMinXValue(double? value) {
    if (_painter.uMinXValue == value) return;
    _painter.uMinXValue = value;
    markNeedsPaint();
  }

  set uMaxXValue(double? value) {
    if (_painter.uMaxXValue == value) return;
    _painter.uMaxXValue = value;
    markNeedsPaint();
  }

  set uMinYValue(double? value) {
    if (_painter.uMinYValue == value) return;
    _painter.uMinYValue = value;
    markNeedsPaint();
  }

  set uMaxYValue(double? value) {
    if (_painter.uMaxYValue == value) return;
    _painter.uMaxYValue = value;
    markNeedsPaint();
  }

  // Mandatory Fields

  set style(CartesianChartStyle value) {
    if (_painter.style == value) return;
    _painter.style = value;
    markNeedsPaint();
  }

  set controller(CartesianController value) {
    if (_painter.controller == value) return;
    _painter.controller = value;
    markNeedsPaint();
  }

  _CartesianChartsState({
    this.width,
    this.height,
    double? uMinXValue,
    double? uMaxXValue,
    double? uMinYValue,
    double? uMaxYValue,
    required CartesianChartStyle style,
    required CartesianController controller,
  }) : _painter = CartesianChartPainter(
          uMinXValue: uMinXValue,
          uMaxXValue: uMaxXValue,
          uMinYValue: uMinYValue,
          uMaxYValue: uMaxYValue,
          style: style,
          controller: controller,
        ) {
    controller.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void performLayout() => size = computeDryLayout(constraints);

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);

    _painter.paint(
      canvas,
      size,
    );
    canvas.restore();
  }

// @override
// Widget build(BuildContext context) {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       return RepaintBoundary(
//         child: CustomPaint(
//           isComplex: true,
//           painter: CartesianChartPainter(
//             uMinXValue: widget.uMinXValue,
//             uMaxXValue: widget.uMaxXValue,
//             uMinYValue: widget.uMinYValue,
//             uMaxYValue: widget.uMaxYValue,
//             style: widget.style,
//             controller: widget.controller,
//           ),
//           child: ConstrainedBox(
//             constraints: BoxConstraints.expand(
//               width: widget.width,
//               height: widget.height,
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
}
