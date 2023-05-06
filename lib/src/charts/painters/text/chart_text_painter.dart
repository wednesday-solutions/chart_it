import 'package:chart_it/src/charts/data/core.dart';
import 'package:flutter/cupertino.dart';

const String _ellipsis = '\u2026';

class ChartTextPainter {
  final String text;
  final TextStyle? style;
  final bool showEllipsis;
  final TextDirection direction;
  final TextAlign align;
  final int maxLines;
  final double? maxWidth;

  late TextPainter _painter;
  Size? textConstraints;

  ChartTextPainter({
    required this.text,
    required this.style,
    required this.showEllipsis,
    this.direction = TextDirection.ltr,
    this.align = TextAlign.center,
    this.maxLines = 1,
    this.maxWidth,
  }) {
    // We will initialize our textPainter on instance
    _painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: direction,
      maxLines: maxLines,
    );
  }

  ChartTextPainter.fromChartTextStyle({
    required this.text,
    required ChartTextStyle chartTextStyle,
    this.maxWidth,
  })  : style = chartTextStyle.textStyle,
        direction = TextDirection.ltr,
        maxLines = chartTextStyle.maxLines,
        showEllipsis = chartTextStyle.ellipsize,
        align = chartTextStyle.align {
    // We will initialize our textPainter on instance
    _painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: direction,
      maxLines: maxLines,
    );
  }

  void layout() {
    if (showEllipsis) {
      _painter.ellipsis = _ellipsis;
    }

    _painter.layout(maxWidth: maxWidth ?? double.infinity);
  }

  double get width => _painter.width;
  double get height => _painter.height;

  void paint(
      {required Canvas canvas,
      required Offset offset,
      bool shouldLayout = false}) {
    if (shouldLayout) {
      layout();
    }

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

    final position = Offset(
      offset.dx - (_painter.width * alignOffset),
      offset.dy - (_painter.height * 0.5),
    );

    _painter.paint(canvas, position);
    textConstraints = _painter.size;
  }
}
