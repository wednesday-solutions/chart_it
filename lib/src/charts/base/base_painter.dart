import 'package:flutter/material.dart';

abstract class BasePainter extends CustomPainter {
  late double graphWidth;
  late double graphHeight;
  late Offset graphOrigin;
  late Rect graphConstraints;

  late double unitWidth;
  late double unitHeight;

  void paintChart(Canvas canvas, Size size);

  @override
  bool shouldRepaint(BasePainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate constraints for the graph
    _calculateGraphConstraints(size);

    // TODO: Create a function for this to handle background
    var bg = Paint()..color = Colors.cyan;
    canvas.drawPaint(bg);

    _drawGridLines(canvas, size);

    // Finally we will handover canvas to the implementing painter
    // to draw plot and draw the chart data
    paintChart(canvas, size);
  }

  void _drawGridLines(Canvas canvas, Size size) {
    var border = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    var x = graphConstraints.left;
    // create vertical lines
    for (var i = 0; i <= 10; i++) {
      var p1 = Offset(x, graphConstraints.bottom);
      var p2 = Offset(x, graphConstraints.top);
      canvas.drawLine(p1, p2, border);

      x += unitWidth;
    }

    // create horizontal lines
    for (var i = 0; i <= 10; i++) {
      var y = graphConstraints.bottom - unitHeight * i;

      var p1 = Offset(graphConstraints.left, y);
      var p2 = Offset(graphConstraints.right, y);
      canvas.drawLine(p1, p2, border);
    }
  }

  // Helper method to draw text on canvas
  void drawText(Canvas canvas, Offset position, {required TextSpan text}) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      text: text,
    );
    textPainter.layout(); // needs to be called before paint method
    // When painter draws the text, it's center is not at the specified position
    // But rather starts from Top Left as it's origin.
    // To align the text's center at the specified offset
    // we reduce half of the width & height of the text painter's constraints
    textPainter.paint(
      canvas,
      Offset(
        position.dx - (textPainter.width * 0.5),
        position.dy - (textPainter.height * 0.5),
      ),
    );
  }

  _calculateGraphConstraints(Size widgetSize) {
    // TODO: Calculate the effective width & height of the graph
    graphOrigin = Offset(widgetSize.width * 0.5, widgetSize.height * 0.5);
    graphWidth = widgetSize.width * 0.8;
    graphHeight = widgetSize.height * 0.8;

    graphConstraints = Rect.fromCenter(
      center: graphOrigin,
      width: graphWidth,
      height: graphHeight,
    );

    // We will get unitWidth & unitHeight by dividing the
    // graphWidth & graphHeight into X parts
    unitWidth = graphWidth / 10;
    unitHeight = graphHeight / 10;
  }
}
