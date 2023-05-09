import 'package:chart_it/src/charts/data/core.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/state/painting_state.dart';
import 'package:chart_it/src/interactions/interactions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// class AxisLabels extends LeafRenderObjectWidget {
//   const AxisLabels({super.key});
//
//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return RenderAxisLabels();
//   }
// }
//
// class RenderAxisLabels extends RenderBox {}
//
// enum ChartScaffoldSlot { center, left, bottom, right, top }
//
// class CartesianScaffold extends RenderObjectWidget
//     with SlottedMultiChildRenderObjectWidgetMixin<ChartScaffoldSlot> {
//   final Widget Function()? leftLabel;
//   final Widget Function()? rightLabel;
//   final Widget Function()? topLabel;
//   final Widget Function()? bottomLabel;
//   final Widget chart;
//
//   CartesianScaffold({
//     this.leftLabel,
//     this.rightLabel,
//     this.topLabel,
//     this.bottomLabel,
//     required this.chart,
//     super.key,
//   });
//
//   @override
//   Widget? childForSlot(ChartScaffoldSlot slot) {
//     switch (slot) {
//       case ChartScaffoldSlot.left:
//         if (leftLabel != null) {
//           return const AxisLabels();
//         }
//         break;
//       case ChartScaffoldSlot.right:
//         // TODO: Handle this case.
//         break;
//       case ChartScaffoldSlot.top:
//         // TODO: Handle this case.
//         break;
//       case ChartScaffoldSlot.bottom:
//         // TODO: Handle this case.
//         break;
//       case ChartScaffoldSlot.center:
//         return chart;
//     }
//     return null;
//   }
//
//   @override
//   SlottedContainerRenderObjectMixin<ChartScaffoldSlot> createRenderObject(
//       BuildContext context) {
//     return _RenderCartesianScaffold();
//   }
//
//   @override
//   // TODO: implement slots
//   Iterable<ChartScaffoldSlot> get slots => ChartScaffoldSlot.values;
// }
//
// class _RenderCartesianScaffold extends RenderBox
//     with SlottedContainerRenderObjectMixin<ChartScaffoldSlot> {
//   @override
//   Size computeDryLayout(BoxConstraints constraints) {
//     return super.computeDryLayout(constraints);
//   }
// }

class CartesianRenderer extends LeafRenderObjectWidget {
  final double? width;
  final double? height;

  // Mandatory Fields
  final CartesianChartStylingData style;
  final CartesianChartStructureData structure;
  final List<PaintingState> states;
  final CartesianRangeResult rangeData;
  final InteractionDispatcher interactionDispatcher;
  final GridUnitsData gridUnitsData;

  const CartesianRenderer({
    Key? key,
    this.width,
    this.height,
    required this.style,
    required this.states,
    required this.rangeData,
    required this.interactionDispatcher,
    required this.structure,
    required this.gridUnitsData,
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
      structure: structure,
      gridUnitsData: gridUnitsData,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    assert(renderObject is CartesianRenderBox);
    (renderObject as CartesianRenderBox)
      ..width = width
      ..height = height
      ..style = style
      ..structure = structure
      ..gridUnitsData = gridUnitsData
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
    required CartesianChartStylingData style,
    required CartesianChartStructureData structure,
    required List<PaintingState> states,
    required CartesianRangeResult rangeData,
    required InteractionDispatcher interactionDispatcher,
    required GridUnitsData gridUnitsData,
  })  : _width = width,
        _height = height,
        _interactionDispatcher = interactionDispatcher,
        _painter = CartesianChartPainter(
          style: style,
          states: states,
          rangeData: rangeData,
          structure: structure,
          gridUnitsData: gridUnitsData
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
