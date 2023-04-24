import 'package:equatable/equatable.dart';

class Pair<A,B> extends Equatable {
  final A first;
  final B second;

  const Pair(this.first, this.second);

  @override
  List<Object?> get props => throw UnimplementedError();

}

extension PairBuilder on Object {
  Pair<A,B> to<A,B>(B second) => Pair(this as A, second);
}