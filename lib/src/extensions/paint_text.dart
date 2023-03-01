import 'package:flutter/painting.dart';

extension PaintText on Canvas {
  // Helper method to draw text on canvas
  void drawText(
    Offset position, {
    required TextSpan text,
    TextAlign align = TextAlign.center,
  }) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: align,
      text: text,
    );
    textPainter.layout(); // needs to be called before paint method
    // When painter draws the text, it's center is not at the specified position
    // But rather starts from Top Left as it's origin.
    // To align the text's center at the specified offset
    // we reduce half of the width & height of the text painter's constraints

    var alignOffset = 0.5;
    switch (align) {
      case TextAlign.start:
        alignOffset = 0;
        break;
      case TextAlign.center:
        alignOffset = 0.5;
        break;
      case TextAlign.end:
        alignOffset = 1.0;
        break;
      default:
        alignOffset = 0.5;
    }

    textPainter.paint(
      this,
      Offset(
        position.dx - (textPainter.width * alignOffset),
        position.dy - (textPainter.height * 0.5),
      ),
    );
  }
}
