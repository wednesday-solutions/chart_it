import 'dart:ui';

import 'package:equatable/equatable.dart';

class PieSeriesStyle extends Equatable {
  final double width;
  final Color pieceColor;
  final double? border;
  final double radius;

  const PieSeriesStyle(
      {required this.width,
      required this.pieceColor,
      this.border,
      required this.radius});

  @override
  List<Object?> get props => [width, pieceColor, border, radius];
}
