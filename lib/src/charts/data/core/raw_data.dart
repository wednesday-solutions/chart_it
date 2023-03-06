import 'package:equatable/equatable.dart';

class RawSeries extends Equatable {
  final num xValue;
  final List<num> yValues;

  const RawSeries({
    required this.xValue,
    required this.yValues,
  });

  @override
  List<Object?> get props => [xValue, yValues];
}
