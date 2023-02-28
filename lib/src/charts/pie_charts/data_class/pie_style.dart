import 'dart:ui';

import 'package:equatable/equatable.dart';

class PieStyle extends Equatable {
  final double? width;
  final Color? pieceColor;
  final double? border;
  final double? radius;

  const PieStyle({this.width, this.pieceColor, this.border, this.radius});

  @override
  List<Object?> get props => [width, pieceColor, border, radius];
}
