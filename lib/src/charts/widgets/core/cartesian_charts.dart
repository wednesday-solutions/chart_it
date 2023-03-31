import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_mixins.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
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
  final List<CartesianSeries> currentData;
  final List<CartesianSeries> targetData;
  final Map<int, CartesianPainter> painters;
  final Map<CartesianSeries, CartesianConfig> configs;
  final CartesianDataMixin cartesianRangeData;

  const CartesianCharts(
      {Key? key,
      this.width,
      this.height,
      this.uMinXValue,
      this.uMaxXValue,
      this.uMinYValue,
      this.uMaxYValue,
      required this.style,
      required this.currentData,
      required this.targetData,
      required this.painters,
      required this.configs,
      required this.cartesianRangeData})
      : super(key: key);

  // @override
  // State<CartesianCharts> createState() => _CartesianChartsState();

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CartesianChartsState(
      style: style,
      currentData: currentData,
      targetData: targetData,
      painters: painters,
      configs: configs,
      cartesianRangeData: cartesianRangeData,
    )
      ..width = width
      ..height = height
      ..uMaxXValue = uMaxXValue
      ..uMaxYValue = uMaxYValue
      ..uMinXValue = uMinXValue
      ..uMinYValue = uMinYValue;
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {
    assert(renderObject is _CartesianChartsState);
    (renderObject as _CartesianChartsState)
      ..width = width
      ..height = height
      ..uMaxXValue = uMaxXValue
      ..uMaxYValue = uMaxYValue
      ..uMinXValue = uMinXValue
      ..uMinYValue = uMinYValue
      ..style = style
      ..currentData = currentData
      ..targetData = targetData
      ..painters = painters
      ..configs = configs;
  }
}

class _CartesianChartsState extends RenderBox {
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

  set currentData(List<CartesianSeries> value) {
    if (_painter.currentData == value) return;
    _painter.currentData = value;
    markNeedsPaint();
  }

  set targetData(List<CartesianSeries> value) {
    if (_painter.targetData == value) return;
    _painter.targetData = value;
    markNeedsPaint();
  }

  set painters(Map<int, CartesianPainter> value) {
    if (_painter.painters != value) return;
    _painter.painters = value;
    markNeedsPaint();
  }

  set configs(Map<CartesianSeries, CartesianConfig> value) {
    if (_painter.configs != value) return;
    _painter.configs = value;
    markNeedsPaint();
  }

  late TapGestureRecognizer _tapGestureRecognizer;
  final _doubleTapGestureRecognizer = DoubleTapGestureRecognizer();

  _CartesianChartsState(
      {double? width,
      double? height,
      double? uMinXValue,
      double? uMaxXValue,
      double? uMinYValue,
      double? uMaxYValue,
      required CartesianChartStyle style,
      required List<CartesianSeries> currentData,
      required List<CartesianSeries> targetData,
      required Map<int, CartesianPainter> painters,
      required Map<CartesianSeries, CartesianConfig> configs,
      required CartesianDataMixin cartesianRangeData})
      : _width = width,
        _height = height,
        _painter = CartesianChartPainter(
            uMinXValue: uMinXValue,
            uMaxXValue: uMaxXValue,
            uMinYValue: uMinYValue,
            uMaxYValue: uMaxYValue,
            style: style,
            currentData: currentData,
            targetData: targetData,
            painters: painters,
            configs: configs,
            cartesianRangeData: cartesianRangeData);

  _registerGestureRecognizers() {
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTapUp = (details) {
        // _painter.controller.onTapUp(details.localPosition);
      };
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    double? height = _height;
    double? width = _width;

    if (width != null && width > constraints.maxWidth) {
      width = constraints.maxWidth;
    }

    if (height != null && height > constraints.maxHeight) {
      height = constraints.maxHeight;
    }

    return Size(width ?? constraints.maxWidth, height ?? constraints.maxHeight);
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
