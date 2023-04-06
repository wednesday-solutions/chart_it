import 'package:chart_it/src/charts/data/core/radial/radial_data.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_mixins.dart';
import 'package:chart_it/src/charts/data/core/radial/radial_styling.dart';
import 'package:chart_it/src/charts/painters/radial/radial_chart_painter.dart';
import 'package:chart_it/src/charts/painters/radial/radial_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RadialRenderer extends LeafRenderObjectWidget {
  final double? width;
  final double? height;

  // Mandatory Fields
  final RadialChartStyle style;
  final List<RadialSeries> currentData;
  final List<RadialSeries> targetData;
  final Map<int, RadialPainter> painters;
  final Map<RadialSeries, RadialConfig> configs;
  final RadialDataMixin radialRangeData;

  const RadialRenderer({
    Key? key,
    this.width,
    this.height,
    required this.style,
    required this.currentData,
    required this.targetData,
    required this.painters,
    required this.configs,
    required this.radialRangeData,
  }) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RadialRenderBox(
      width: width,
      height: height,
      style: style,
      currentData: currentData,
      targetData: targetData,
      painters: painters,
      configs: configs,
      rangeData: radialRangeData,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    assert(renderObject is RadialRenderBox);
    (renderObject as RadialRenderBox)
      ..width = width
      ..height = height
      ..style = style
      ..currentData = currentData
      ..targetData = targetData
      ..painters = painters
      ..configs = configs;
  }
}

class RadialRenderBox extends RenderBox {
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

  final RadialChartPainter _painter;

  // Mandatory Fields
  set style(RadialChartStyle value) {
    if (_painter.style == value) return;
    _painter.style = value;
    markNeedsPaint();
  }

  set currentData(List<RadialSeries> value) {
    if (_painter.currentData == value) return;
    _painter.currentData = value;
    markNeedsPaint();
  }

  set targetData(List<RadialSeries> value) {
    if (_painter.targetData == value) return;
    _painter.targetData = value;
    markNeedsPaint();
  }

  set painters(Map<int, RadialPainter> value) {
    if (_painter.painters != value) return;
    _painter.painters = value;
    markNeedsPaint();
  }

  set configs(Map<RadialSeries, RadialConfig> value) {
    if (_painter.configs != value) return;
    _painter.configs = value;
    markNeedsPaint();
  }

  late TapGestureRecognizer _tapGestureRecognizer;
  final _doubleTapGestureRecognizer = DoubleTapGestureRecognizer();

  RadialRenderBox({
    double? width,
    double? height,
    required RadialChartStyle style,
    required RadialDataMixin rangeData,
    required List<RadialSeries> currentData,
    required List<RadialSeries> targetData,
    required Map<int, RadialPainter> painters,
    required Map<RadialSeries, RadialConfig> configs,
  })  : _width = width,
        _height = height,
        _painter = RadialChartPainter(
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
  void performLayout() => size = computeDryLayout(constraints);

  @override
  Size computeDryLayout(BoxConstraints constraints) => Size(
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
}
