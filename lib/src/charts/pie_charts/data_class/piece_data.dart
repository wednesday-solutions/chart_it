import 'dart:ui';

import 'package:equatable/equatable.dart';

class PieceData extends Equatable {
  final int value;
  final Color pieceColor;

  const PieceData({required this.value, required this.pieceColor});

  @override
  List<Object?> get props => [value, pieceColor];
}
