import 'dart:ui';

import 'package:equatable/equatable.dart';

class PieStyle extends Equatable {
  final double? width;
  final Color? pieceColor;
  final double? borderWidth;
  final Color? borderColor;
  final double? radius;

  const PieStyle(
      {this.width,
      this.pieceColor,
      this.borderWidth,
      this.borderColor,
      this.radius});

  @override
  List<Object?> get props =>
      [width, pieceColor, borderWidth, borderColor, radius];
}
