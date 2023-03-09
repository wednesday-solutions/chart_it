import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ChartTextStyle extends Equatable {
  final TextStyle? textStyle;
  final int maxLines;
  final bool ellipsize;
  final TextAlign align;

  const ChartTextStyle({
    this.textStyle,
    this.align = TextAlign.center,
    this.maxLines = 1,
    this.ellipsize = true,
  });

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
