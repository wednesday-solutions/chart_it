import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CartesianRenderer extends LeafRenderObjectWidget {
  final double? width;
  final double? height;

  // Mandatory Fields
  final CartesianChartStyle style;
  final List<PaintingState> states;
  final CartesianRangeResult rangeData;
  final InteractionDispatcher interactionDispatcher;

  const CartesianRenderer({
    Key? key,
    this.width,
    this.height,
    required this.style,
    required this.states,
    required this.rangeData,
    required this.interactionDispatcher,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CartesianRenderBox(
      width: width,
      height: height,
      style: style,
      states: states,
      rangeData: rangeData,
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
      ..states = states
      ..range = rangeData
      ..interactionDispatcher = interactionDispatcher;
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
  InteractionDispatcher _interactionDispatcher;
  set interactionDispatcher(InteractionDispatcher value) {
    _interactionDispatcher = value;
  }

  // Mandatory Fields
  set style(CartesianChartStyle value) {
    if (_painter.style == value) return;
    _painter.style = value;
    markNeedsPaint();
  }

  set states(List<PaintingState> value) {
    if (_painter.states == value) return;
    _painter.states = value;
    markNeedsPaint();
  }

  set range(CartesianRangeResult value) {
    if (_painter.rangeData == value) return;
    _painter.rangeData = value;
    markNeedsPaint();
  }

  late final TapGestureRecognizer _tapGestureRecognizer;
  late final DoubleTapGestureRecognizer _doubleTapGestureRecognizer;
  late final PanGestureRecognizer _panGestureRecognizer;

  CartesianRenderBox({
    double? width,
    double? height,
    required CartesianChartStyle style,
    required List<PaintingState> states,
    required CartesianRangeResult rangeData,
    required InteractionDispatcher interactionDispatcher,
  })  : _width = width,
        _height = height,
        _interactionDispatcher = interactionDispatcher,
        _painter = CartesianChartPainter(
          style: style,
          states: states,
          rangeData: rangeData,
        );

  _registerGestureRecognizers() {
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTapUp = _interactionDispatcher.onTapUp
      ..onTapCancel = _interactionDispatcher.onTapCancel
      ..onTap = _interactionDispatcher.onTap
      ..onTapDown = _interactionDispatcher.onTapDown;

    _doubleTapGestureRecognizer = DoubleTapGestureRecognizer()
      ..onDoubleTap = _interactionDispatcher.onDoubleTap
      ..onDoubleTapDown = _interactionDispatcher.onDoubleTapDown
      ..onDoubleTapCancel = _interactionDispatcher.onDoubleTapCancel;

    _panGestureRecognizer = PanGestureRecognizer()
      ..onStart = _interactionDispatcher.onPanStart
      ..onUpdate = _interactionDispatcher.onPanUpdate
      ..onCancel = _interactionDispatcher.onPanCancel
      ..onEnd = _interactionDispatcher.onPanEnd;
  }

  @override
  void performLayout() => size = computeDryLayout(constraints);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      Size(_width ?? constraints.maxWidth, _height ?? constraints.maxHeight);

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
      if (_interactionDispatcher.tapRecognitionEnabled) {
        _tapGestureRecognizer.addPointer(event);
      }
      if (_interactionDispatcher.doubleTapRecognitionEnabled) {
        _doubleTapGestureRecognizer.addPointer(event);
      }
      if (_interactionDispatcher.dragRecognitionEnabled) {
        _panGestureRecognizer.addPointer(event);
      }
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
