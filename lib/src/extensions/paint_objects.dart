import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

extension PaintObjects on Canvas {
  // Helper method to draw given objects rotated
  void drawRotated(Offset center, double angle, VoidCallback drawObjects) {
    save();
    translate(center.dx, center.dy);
    rotate(angle);
    translate(-center.dx, -center.dy);
    drawObjects.call();
    restore();
  }
}

extension ShaderConvert on Gradient {
  ui.Shader toShader(Rect shape) {
    switch (runtimeType) {
      case LinearGradient:
        return (this as LinearGradient).createShader(
          shape,
          textDirection: TextDirection.ltr,
        );
      case RadialGradient:
        return (this as RadialGradient).createShader(
          shape,
          textDirection: TextDirection.ltr,
        );
      case SweepGradient:
        return (this as SweepGradient).createShader(
          shape,
          textDirection: TextDirection.ltr,
        );
      default:
        throw TypeError();
    }
  }
}
