import 'dart:developer';

import 'package:chart_it/src/charts/data/core/cartesian/cartesian_data.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_mixins.dart';
import 'package:chart_it/src/charts/data/core/cartesian/cartesian_styling.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_chart_painter.dart';
import 'package:chart_it/src/charts/painters/cartesian/cartesian_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CartesianCharts extends LeafRenderObjectWidget {
  final double? width;
  final double? height;

  // Mandatory Fields
  final CartesianChartStyle style;
  final List<CartesianSeries> currentData;
  final List<CartesianSeries> targetData;
  final Map<int, CartesianPainter> painters;
  final Map<CartesianSeries, CartesianConfig> configs;
  final CartesianDataMixin cartesianRangeData;

  const CartesianCharts({
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
    return _CartesianChartsState(
      width: width,
      height: height,
      style: style,
      currentData: currentData,
      targetData: targetData,
      painters: painters,
      configs: configs,
      rangeData: cartesianRangeData,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    assert(renderObject is _CartesianChartsState);
    (renderObject as _CartesianChartsState)
      ..width = width
      ..height = height
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

  _CartesianChartsState({
    double? width,
    double? height,
    required CartesianChartStyle style,
    required CartesianDataMixin rangeData,
    required List<CartesianSeries> currentData,
    required List<CartesianSeries> targetData,
    required Map<int, CartesianPainter> painters,
    required Map<CartesianSeries, CartesianConfig> configs,
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
    Timeline.startSync('Main Paint');
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    _painter.paint(
      canvas,
      size,
    );
    canvas.restore();
    Timeline.finishSync();
  }
}
