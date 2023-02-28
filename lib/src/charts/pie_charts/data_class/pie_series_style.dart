import 'dart:ui';

import 'package:equatable/equatable.dart';

class PieSeriesStyle extends Equatable {
  final double width;
  final Color pieceColor;
  final double? borderWidth;
  final Color? borderColor;
  final double radius;

  const PieSeriesStyle(
      {required this.width,
      required this.pieceColor,
      this.borderWidth,
      this.borderColor,
      required this.radius});

  @override
  List<Object?> get props =>
      [width, pieceColor, borderWidth, radius, borderColor];
}
