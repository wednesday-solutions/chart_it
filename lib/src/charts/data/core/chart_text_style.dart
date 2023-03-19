import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Provides Uniform Text Styling across All Charts
class ChartTextStyle extends Equatable {
  /// Styling for the Text
  final TextStyle? textStyle;

  /// Max Lines to Show for a Text.
  /// Defaults to 1
  final int maxLines;

  /// Show/Hide Ellipses on TextOverflow
  final bool ellipsize;

  /// Alignment of the Text
  final TextAlign align;

  const ChartTextStyle({
    this.textStyle,
    this.align = TextAlign.center,
    this.maxLines = 1,
    this.ellipsize = true,
  });

  static ChartTextStyle lerp(ChartTextStyle? current, ChartTextStyle? target, double t) {
    return ChartTextStyle(
      textStyle: TextStyle.lerp(current?.textStyle, target?.textStyle, t),
      maxLines: target?.maxLines ?? 1,
      align: target?.align ?? TextAlign.center,
      ellipsize: target?.ellipsize ?? true,
    );
  }

  @override
  List<Object?> get props => [textStyle, maxLines, ellipsize, align];

  ChartTextStyle copyWith({
    TextStyle? textStyle,
    int? maxLines,
    bool? ellipsize,
    TextAlign? align,
  }) {
    return ChartTextStyle(
      textStyle: textStyle ?? this.textStyle,
      maxLines: maxLines ?? this.maxLines,
      ellipsize: ellipsize ?? this.ellipsize,
      align: align ?? this.align,
    );
  }
}
