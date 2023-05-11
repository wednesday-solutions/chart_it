import 'dart:math';

import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/charts/renderers/cartesian_scaffold_renderer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

enum AxisOrientation { vertical, horizontal }

class AxisLabels extends MultiChildRenderObjectWidget {
  final GridUnitsData gridUnitsData;
  final AxisOrientation orientation;
  final bool constraintEdgeLabels;
  final bool centerLabels;

  AxisLabels({
    super.key,
    required this.gridUnitsData,
    required this.orientation,
    this.constraintEdgeLabels = false,
    this.centerLabels = false,
    required Widget Function(int index, double value) labelBuilder,
  })  : assert(!(constraintEdgeLabels && centerLabels),
            "Both centerLabels and constraintEdgeLabels cannot be true at the same time."),
        super(
          children: List.generate(
            (orientation == AxisOrientation.vertical
                    ? gridUnitsData.yUnitsCount.toInt()
                    : gridUnitsData.xUnitsCount.toInt()) +
                (centerLabels ? 0 : 1),
            (index) {
              final minValue = orientation == AxisOrientation.vertical
                  ? gridUnitsData.minYRange
                  : gridUnitsData.minXRange;
              final step = orientation == AxisOrientation.vertical
                  ? gridUnitsData.yUnitValue
                  : gridUnitsData.xUnitValue;
              final value = minValue + step * index;
              return labelBuilder(index, value);
            },
          ),
        );

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAxisLabels(
        gridUnitsData: gridUnitsData,
        orientation: orientation,
        constraintEdgeLabels: constraintEdgeLabels,
        centerLabels: centerLabels);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderAxisLabels renderObject,
  ) {
    renderObject
      ..gridUnitsData = gridUnitsData
      ..orientation = orientation
      ..constraintEdgeLabels = constraintEdgeLabels
      ..centerLabels = centerLabels;
  }
}

class RenderAxisLabels extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  GridUnitsData _gridUnitsData;

  set gridUnitsData(GridUnitsData value) {
    if (_gridUnitsData == value) return;

    if (_gridUnitsData.xUnitsCount != value.xUnitsCount ||
        _gridUnitsData.yUnitsCount != value.yUnitsCount ||
        _gridUnitsData.totalYRange != value.totalYRange ||
        _gridUnitsData.totalXRange != value.totalXRange) {
      markNeedsLayout();
    }
    _gridUnitsData = value;
    markNeedsPaint();
  }

  AxisOrientation _orientation;

  set orientation(AxisOrientation value) {
    if (_orientation == value) return;
    _orientation = value;
    markNeedsLayout();
  }

  bool _constraintEdgeLabels;

  set constraintEdgeLabels(bool value) {
    if (_constraintEdgeLabels == value) return;
    _constraintEdgeLabels = value;
    markNeedsPaint();
  }

  bool _centerLabels;

  set centerLabels(bool value) {
    if (_centerLabels == value) return;
    _centerLabels = value;
    markNeedsPaint();
  }

  RenderAxisLabels({
    required GridUnitsData gridUnitsData,
    required AxisOrientation orientation,
    required bool constraintEdgeLabels,
    required bool centerLabels,
  })  : _gridUnitsData = gridUnitsData,
        _orientation = orientation,
        _constraintEdgeLabels = constraintEdgeLabels,
        _centerLabels = centerLabels;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    var child = firstChild;
    late final BoxConstraints childConstraints;

    if (_orientation == AxisOrientation.vertical) {
      childConstraints = BoxConstraints(
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight / _gridUnitsData.yUnitsCount);
    } else {
      childConstraints = BoxConstraints(
          maxWidth: constraints.maxWidth / _gridUnitsData.xUnitsCount,
          maxHeight: constraints.maxHeight);
    }

    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);
      child = (child.parentData as MultiChildLayoutParentData).nextSibling;
    }
    return Size(constraints.maxWidth, constraints.maxHeight);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    var child = firstChild;
    var height = 0.0;
    while (child != null) {
      final parentData = (child.parentData as MultiChildLayoutParentData);
      height = max(height, child.getMinIntrinsicHeight(width));
      child = parentData.nextSibling;
    }
    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    var child = firstChild;
    var height = 0.0;
    while (child != null) {
      final parentData = (child.parentData as MultiChildLayoutParentData);
      height = max(height, child.getMaxIntrinsicHeight(width));
      child = parentData.nextSibling;
    }
    return height;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    var child = firstChild;
    var width = 0.0;
    while (child != null) {
      final parentData = (child.parentData as MultiChildLayoutParentData);
      width = max(width, child.getMinIntrinsicWidth(width));
      child = parentData.nextSibling;
    }
    return width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    var child = firstChild;
    var width = 0.0;
    while (child != null) {
      final parentData = (child.parentData as MultiChildLayoutParentData);
      width = max(width, child.getMaxIntrinsicWidth(width));
      child = parentData.nextSibling;
    }
    return width;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paintingGeometryData =
        (parentData as CartesianScaffoldParentData).paintingGeometryData;

    if (_orientation == AxisOrientation.vertical) {
      // var child = firstChild;
      // Offset childOffset = Offset(offset.dx,
      //     paintingGeometryData.graphPolygon.bottom - (child?.size.height ?? 0));
      // var index = 0;
      // while (child != null) {
      //   context.paintChild(child, childOffset);
      //   childOffset = Offset(
      //       offset.dx, childOffset.dy - paintingGeometryData.graphUnitHeight);
      //
      //   if (_constraintEdgeLabels) {
      //     if (index == 0) {
      //       childOffset += Offset(0, child.size.height / 2);
      //     }
      //
      //     if (index == childCount - 2) {
      //       childOffset += Offset(0, child.size.height / 4);
      //     }
      //   }
      //
      //   index++;
      //   child = (child.parentData as MultiChildLayoutParentData).nextSibling;
      // }

      var child = firstChild;
      Offset childOffset =
          Offset(offset.dx, paintingGeometryData.graphPolygon.bottom);
      var index = 0;
      while (child != null) {
        Offset paintingOffset = childOffset;

        if (_centerLabels) {
          paintingOffset -= Offset(0, paintingGeometryData.graphUnitHeight / 2);
        }

        if (_constraintEdgeLabels) {
          if (index == 0) {
            paintingOffset -= Offset(0, child.size.height / 2);
          }

          if (index == childCount - 1) {
            paintingOffset += Offset(0, child.size.height / 2);
          }
        }

        context.paintChild(
            child, paintingOffset - Offset(0, child.size.height / 2));

        childOffset -= Offset(0, paintingGeometryData.graphUnitHeight);
        index++;
        child = (child.parentData as MultiChildLayoutParentData).nextSibling;
      }
    }

    if (_orientation == AxisOrientation.horizontal) {
      // var child = firstChild;
      // Offset childOffset = Offset(offset.dx - (child?.size.width ?? 0) / 2, offset.dy);
      // var index = 0;
      // while (child != null) {
      //   context.paintChild(child, childOffset);
      //   childOffset = Offset(
      //       childOffset.dx + paintingGeometryData.graphUnitWidth,
      //       childOffset.dy);
      //
      //   if (_constraintEdgeLabels || true) {
      //     if (index == 0) {
      //       childOffset += Offset(child.size.width / 2, 0);
      //     }
      //
      //     if (index == childCount - 2) {
      //       childOffset -= Offset(child.size.width / 2, 0);
      //     }
      //   }
      //
      //   index++;
      //   child = (child.parentData as MultiChildLayoutParentData).nextSibling;
      // }

      var child = firstChild;
      Offset childOffset = offset;
      var index = 0;
      while (child != null) {
        Offset paintOffset = childOffset;

        if (_centerLabels) {
          paintOffset += Offset(paintingGeometryData.graphUnitWidth / 2, 0);
        }

        if (_constraintEdgeLabels) {
          if (index == 0) {
            paintOffset += Offset(child.size.width / 2, 0);
          }

          if (index == childCount - 1) {
            paintOffset -= Offset(child.size.width / 2, 0);
          }
        }

        context.paintChild(
            child, paintOffset - Offset(child.size.width / 2, 0));

        childOffset += Offset(
          paintingGeometryData.graphUnitWidth,
          0,
        );

        index++;
        child = (child.parentData as MultiChildLayoutParentData).nextSibling;
      }
    }
  }
}
