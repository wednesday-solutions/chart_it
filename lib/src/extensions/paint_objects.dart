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
