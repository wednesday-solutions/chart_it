import 'package:equatable/equatable.dart';

/// {@template Fuzziness}
/// [Fuzziness] extends the boundaries for touch detection.
///
/// For example: If [Fuzziness.all(10)] is applied, the area for touch detection
/// will be increased by 10 in all directions.
/// {@endtemplate}
class Fuzziness extends Equatable {
  final double top;
  final double bottom;
  final double left;
  final double right;

  /// {@macro Fuzziness}
  const Fuzziness({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  /// {@macro Fuzziness}
  const Fuzziness.only({
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  });

  /// {@macro Fuzziness}
  const Fuzziness.all(double fuzziness)
      : top = fuzziness,
        bottom = fuzziness,
        left = fuzziness,
        right = fuzziness;

  /// {@macro Fuzziness}
  const Fuzziness.symmetric({
    required double width,
    required double height,
  })  : top = height,
        bottom = height,
        left = width,
        right = width;

  /// {@macro Fuzziness}
  const Fuzziness.zero()
      : top = 0,
        bottom = 0,
        left = 0,
        right = 0;

  @override
  List<Object?> get props => [left, right, top, bottom];
}
