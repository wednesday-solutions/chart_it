import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_styling.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/controllers/cartesian_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  final List<CartesianSeries> currentData;
  final List<CartesianSeries> targetData;
  final Map<int, CartesianPainter> painters;
  final Map<CartesianSeries, CartesianConfig> configs;

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
    required this.currentData,
    required this.targetData,
    required this.painters,
    required this.configs,
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

  // set controller(CartesianController value) {
  //   if (_painter.controller == value) return;
  //   _painter.controller = value;
  //   markNeedsPaint();
  // }

  late TapGestureRecognizer _tapGestureRecognizer;
  final _doubleTapGestureRecognizer = DoubleTapGestureRecognizer();

  _CartesianChartsState({
    this.width,
    this.height,
    double? uMinXValue,
    double? uMaxXValue,
    double? uMinYValue,
    double? uMaxYValue,
    required CartesianChartStyle style,
  }) : _painter = CartesianChartPainter(
          uMinXValue: uMinXValue,
          uMaxXValue: uMaxXValue,
          uMinYValue: uMinYValue,
          uMaxYValue: uMaxYValue,
          style: style,
        );

  _registerGestureRecognizers() {
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTapUp = (details) {
        _painter.controller.onTapUp(details.localPosition);
      };
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
      _doubleTapGestureRecognizer.addPointer(event);
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    print("Painting at ${_painter.controller.animation.value}");
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
