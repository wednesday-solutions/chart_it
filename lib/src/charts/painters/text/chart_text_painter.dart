import 'package:flutter/cupertino.dart';
import 'package:flutter_charts/src/charts/data/core/chart_text_style.dart';

const String _ellipsis = '\u2026';

class ChartTextPainter {
  final String text;
  final TextStyle? style;
  final TextDirection direction;
  final double? maxWidth;
  final int maxLines;
  final bool showEllipsis;
  final TextAlign align;

  ChartTextPainter(
      {required this.text,
      required this.style,
      this.direction = TextDirection.ltr,
      this.maxWidth,
      this.maxLines = 1,
      required this.showEllipsis,
      this.align = TextAlign.center});

  ChartTextPainter.fromChartTextStyle({
    required this.text,
    this.maxWidth,
    required ChartTextStyle chartTextStyle,
  })  : style = chartTextStyle.textStyle,
        direction = TextDirection.ltr,
        maxLines = chartTextStyle.maxLines,
        showEllipsis = chartTextStyle.ellipsize,
        align = chartTextStyle.align;

  void paint({required Canvas canvas, required Offset offset}) {
    var painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: direction,
        maxLines: maxLines);

    if (showEllipsis) {
      painter.ellipsis = _ellipsis;
    }

    painter.layout(maxWidth: maxWidth ?? double.infinity);

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
      offset.dx - (painter.width * alignOffset),
      offset.dy - (painter.height * 0.5),
    );

    painter.paint(canvas, position);
  }
}
