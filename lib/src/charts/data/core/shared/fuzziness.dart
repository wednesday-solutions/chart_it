import 'package:equatable/equatable.dart';

class Fuzziness extends Equatable {
  final double top;
  final double bottom;
  final double left;
  final double right;

  const Fuzziness({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  const Fuzziness.only({
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });

  const Fuzziness.symmetric({
    required double width,
    required double height,
  })  : top = height,
        bottom = height,
        left = width,
        right = width;

  const Fuzziness.zero()
      : top = 0,
        bottom = 0,
        left = 0,
        right = 0;

  @override
  List<Object?> get props => [left, right, top, bottom];
}
