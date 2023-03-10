import 'package:flutter/cupertino.dart';
import 'package:flutter_charts/src/charts/data/core/chart_text_style.dart';

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
  late Size textConstraints;

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
    textConstraints = _painter.size;
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
    textConstraints = _painter.size;
  }

  void paint({required Canvas canvas, required Offset offset}) {
    if (showEllipsis) {
      _painter.ellipsis = _ellipsis;
    }

    _painter.layout(maxWidth: maxWidth ?? double.infinity);

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
  }
}
