import 'package:chart_it/chart_it.dart';
import 'package:chart_it/src/extensions/data_conversions.dart';
import 'package:chart_it/src/extensions/validators.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

mixin SeriesAggregatorMixin<T> {
  void aggregateData(List<T> data);
}

typedef ValueMapper<T> = Tuple2<double, double> Function(T data);
typedef BarSeriesMapper = Function(
  BarSeries data,
  ValueMapper<BarGroup> minMaxValue,
);

class TempController with SeriesAggregatorMixin<CartesianSeries> {
  List<CartesianSeries> data;

  @override
  List<BarSeriesReducer> reducers;

  TempController({
    required this.data,
    required this.reducers,
  });

  @override
  void aggregateData(List<CartesianSeries> data) {
    // How many times we may need to iterate over our data
    var iterations = data.maxIterations();
    for (var i = 0; i < iterations; i++) {
      // TODO: iterate over the n'th index of every series
      for (var series in data) {
        whereSeries(
          series.runtimeType,
          onBarSeries: () {
            var barSeries = series as BarSeries;
            if (i < barSeries.barData.length) {
              // TODO: We Know the index. We have to get the min/max values
              //  from the 'i'th element(BarGroup) in this series
            }

            // TODO: Provide a callback hook to allow user to do something for this iteration
          },
        );
      }
    }
  }
}

class TempWidget extends StatefulWidget {
  const TempWidget({Key? key}) : super(key: key);

  @override
  State<TempWidget> createState() => _TempWidgetState();
}

class _TempWidgetState extends State<TempWidget> {
  late TempController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TempController(
      data: [
        BarSeries.zero(),
      ],
      reducers: [
        BarSeriesReducer(
          onReduce: (index, groupLength) {
            // _maxBarsInGroup = max(_maxBarsInGroup, groupLength);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// Singleton Reducer
class BarSeriesReducer {
  BarSeriesReducer._();

  // Ensure our reducer always has only one instance.
  static final BarSeriesReducer _instance = BarSeriesReducer._();

  late Function(int index, double groupLength) onReduce;

  factory BarSeriesReducer({
    required Function(int index, double groupLength) onReduce,
  }) {
    _instance.onReduce = onReduce;
    return _instance;
  }

  Tuple2<double, double>? reduce(BarSeries data) {
    // TODO: return min & max Y values here
  }
}
