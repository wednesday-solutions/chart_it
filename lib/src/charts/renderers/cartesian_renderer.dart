import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data_internal.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/renderers/cartesian_scaffold_renderer.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CartesianChartContainer extends LeafRenderObjectWidget {
  // Mandatory Fields
  final CartesianChartStylingData style;
  final CartesianChartStructureData structure;
  final List<PaintingState> states;
  final InteractionDispatcher interactionDispatcher;
  final GridUnitsData gridUnitsData;

  const CartesianChartContainer({
    Key? key,
    required this.style,
    required this.states,
    required this.interactionDispatcher,
    required this.structure,
    required this.gridUnitsData,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCartesianChartContainer(
      style: style,
      states: states,
      interactionDispatcher: interactionDispatcher,
      structure: structure,
      gridUnitsData: gridUnitsData,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    assert(renderObject is RenderCartesianChartContainer);
    (renderObject as RenderCartesianChartContainer)
      ..style = style
      ..structure = structure
      ..gridUnitsData = gridUnitsData
      ..states = states
      ..interactionDispatcher = interactionDispatcher;
  }
}

class RenderCartesianChartContainer extends RenderBox {
  final CartesianChartPainter _painter;
  InteractionDispatcher _interactionDispatcher;

  set interactionDispatcher(InteractionDispatcher value) {
    _interactionDispatcher = value;
  }

  // Mandatory Fields
  set style(CartesianChartStylingData value) {
    if (_painter.style == value) return;
    _painter.style = value;
    markNeedsPaint();
  }

  set structure(CartesianChartStructureData value) {
    if (_painter.style == value) return;
    _painter.structure = value;
    markNeedsPaint();
  }

  set gridUnitsData(GridUnitsData value) {
    if (_painter.gridUnitsData == value) return;
    _painter.gridUnitsData = value;
    markNeedsPaint();
  }

  set states(List<PaintingState> value) {
    if (_painter.states == value) return;
    _painter.states = value;
    markNeedsPaint();
  }

  late final TapGestureRecognizer _tapGestureRecognizer;
  late final DoubleTapGestureRecognizer _doubleTapGestureRecognizer;
  late final PanGestureRecognizer _panGestureRecognizer;

  RenderCartesianChartContainer({
    double? width,
    double? height,
    required CartesianChartStylingData style,
    required CartesianChartStructureData structure,
    required List<PaintingState> states,
    required InteractionDispatcher interactionDispatcher,
    required GridUnitsData gridUnitsData,
  })  : _interactionDispatcher = interactionDispatcher,
        _painter = CartesianChartPainter(
          style: style,
          states: states,
          structure: structure,
          gridUnitsData: gridUnitsData,
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
      Size(constraints.maxWidth, constraints.maxHeight);

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
    assert(parentData is CartesianScaffoldParentData,
        "${parentData.runtimeType} is not a subclass of $CartesianScaffoldParentData. $CartesianChartContainer should be a direct child of $CartesianScaffold.");
    final paintingGeometryData =
        (parentData as CartesianScaffoldParentData).paintingGeometryData;
    _painter.paint(context.canvas, size, paintingGeometryData);
  }

  @override
  bool get isRepaintBoundary => true;
}
