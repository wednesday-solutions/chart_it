import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_mixins.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_styling.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:chart_it/src/interactions/hit_test/interaction_dispatcher.dart';
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
  late DoubleTapGestureRecognizer _doubleTapGestureRecognizer;
  late PanGestureRecognizer _panGestureRecognizer;

  CartesianRenderBox({
    double? width,
    double? height,
    required CartesianChartStyle style,
    required CartesianDataMixin rangeData,
    required List<CartesianSeries> currentData,
    required List<CartesianSeries> targetData,
    required Map<int, CartesianPainter> painters,
    required Map<CartesianSeries, CartesianConfig> configs,
    required InteractionDispatcher interactionDispatcher,
  })
      : _width = width,
        _height = height,
        _painter = CartesianChartPainter(
          style: style,
          rangeData: rangeData,
          currentData: currentData,
          targetData: targetData,
          painters: painters,
          configs: configs,
          interactionDispatcher: interactionDispatcher,
        );

  _registerGestureRecognizers() {
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTapUp = (details) {
        _painter.interactionDispatcher.onTapUp(details.localPosition);
      };

    _doubleTapGestureRecognizer = DoubleTapGestureRecognizer()
      ..onDoubleTapDown = (details) {
        _painter.interactionDispatcher.onDoubleTapDown(details.localPosition);
      }
      ..onDoubleTap = () {
        _painter.interactionDispatcher.onDoubleTap();
      };
  }

  @override
  void performLayout() => size = computeDryLayout(constraints);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      Size(
        _width ?? constraints.maxWidth,
        _height ?? constraints.maxHeight,
      );

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
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    _painter.paint(canvas, size);
    canvas.restore();
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _registerGestureRecognizers();
  }

  @override
  void detach() {
    _tapGestureRecognizer.dispose();
    super.detach();
  }
}
