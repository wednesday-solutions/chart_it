import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CartesianRenderer extends LeafRenderObjectWidget {
  final double? width;
  final double? height;

  // Mandatory Fields
  final CartesianChartStyle style;
  final List<CartesianSeries> currentData;
  final List<CartesianSeries> targetData;
  final Map<int, CartesianPainter> painters;
  final Map<CartesianSeries, CartesianConfig> configs;
  final CartesianDataMixin cartesianRangeData;
  final InteractionDispatcher interactionDispatcher;

  const CartesianRenderer({
    Key? key,
    this.width,
    this.height,
    required this.style,
    required this.currentData,
    required this.targetData,
    required this.painters,
    required this.configs,
    required this.cartesianRangeData,
    required this.interactionDispatcher,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CartesianRenderBox(
      width: width,
      height: height,
      style: style,
      currentData: currentData,
      targetData: targetData,
      painters: painters,
      configs: configs,
      rangeData: cartesianRangeData,
      interactionDispatcher: interactionDispatcher,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    assert(renderObject is CartesianRenderBox);
    (renderObject as CartesianRenderBox)
      ..width = width
      ..height = height
      ..style = style
      ..currentData = currentData
      ..targetData = targetData
      ..painters = painters
      ..configs = configs;
  }
}

class CartesianRenderBox extends RenderBox {
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
  final InteractionDispatcher interactionDispatcher;

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

  late final TapGestureRecognizer _tapGestureRecognizer;
  late final DoubleTapGestureRecognizer _doubleTapGestureRecognizer;
  late final PanGestureRecognizer _panGestureRecognizer;

  CartesianRenderBox({
    double? width,
    double? height,
    required CartesianChartStyle style,
    required CartesianDataMixin rangeData,
    required List<CartesianSeries> currentData,
    required List<CartesianSeries> targetData,
    required Map<int, CartesianPainter> painters,
    required Map<CartesianSeries, CartesianConfig> configs,
    required this.interactionDispatcher,
  })  : _width = width,
        _height = height,
        _painter = CartesianChartPainter(
          style: style,
          rangeData: rangeData,
          currentData: currentData,
          targetData: targetData,
          painters: painters,
          configs: configs,
        );

  _registerGestureRecognizers() {
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTapUp = interactionDispatcher.onTapUp;

    _doubleTapGestureRecognizer = DoubleTapGestureRecognizer()
      ..onDoubleTap = interactionDispatcher.onDoubleTap
      ..onDoubleTapDown = interactionDispatcher.onDoubleTapDown
      ..onDoubleTapCancel = interactionDispatcher.onDoubleTapCancel;

    _panGestureRecognizer = PanGestureRecognizer()
      ..onStart = interactionDispatcher.onPanStart
      ..onUpdate = interactionDispatcher.onPanUpdate
      ..onCancel = interactionDispatcher.onPanCancel
      ..onEnd = interactionDispatcher.onPanEnd;
  }


  @override
  void performLayout() => size = computeDryLayout(constraints);

  @override
  Size computeDryLayout(BoxConstraints constraints) => Size(
        _width ?? constraints.maxWidth,
        _height ?? constraints.maxHeight,
      );

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _registerGestureRecognizers();
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
      _doubleTapGestureRecognizer.addPointer(event);
      _panGestureRecognizer.addPointer(event);
    } else if (event is PointerHoverEvent) {
      // TODO: Handle onHover() for Web & Desktops
    } else if (event is PointerScrollEvent || event is PointerScaleEvent) {
      // TODO: Handle onScaleUp/onScaleDown events
    }
  }

  @override
  void detach() {
    super.detach();
    _tapGestureRecognizer.dispose();
    _doubleTapGestureRecognizer.dispose();
    _panGestureRecognizer.dispose();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    _painter.paint(canvas, size);
    canvas.restore();
  }
}
