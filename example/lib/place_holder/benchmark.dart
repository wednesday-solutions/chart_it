import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

var rng = Random();

class BenchmarkSample extends StatefulWidget {
  const BenchmarkSample({super.key});

  final Color barColor = const Color(0xFF6D71EE);
  final Color touchedBarColor = Colors.greenAccent;

  @override
  State<StatefulWidget> createState() => BenchmarkSampleState();
}

class BenchmarkSampleState extends State<BenchmarkSample> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: BarChart(
                          randomData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.greenAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        if (isPlaying) refreshState();
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Center(
          child: SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              child: const Text('Randomize Data'),
              onPressed: () => setState(() {}),
            ),
          ),
        )
      ],
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 60,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF191FC8),
              Color(0xFF4247E8),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
          borderSide: isTouched
              ? const BorderSide(color: Colors.white, width: 3.0)
              : const BorderSide(color: Color(0xFF6D71EE), width: 3.0),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(10, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 12.5, isTouched: i == touchedIndex);
          case 7:
            return makeGroupData(7, 3.5, isTouched: i == touchedIndex);
          case 8:
            return makeGroupData(8, 18.5, isTouched: i == touchedIndex);
          case 9:
            return makeGroupData(9, 5.5, isTouched: i == touchedIndex);
          case 10:
            return makeGroupData(10, 24.5, isTouched: i == touchedIndex);
          default:
            return makeGroupData(0, 5, isTouched: i == touchedIndex);
        }
      });

  BarChartData randomData() {
    double next(num min, num max) => rng.nextDouble() * (max - min) + min;
    return BarChartData(
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitles,
            reservedSize: 38,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(
        10,
        (i) {
          return makeGroupData(
            i,
            next(15, 100),
            barColor: widget.barColor,
          );
        },
      ),
      gridData: FlGridData(
        show: true,
        // checkToShowHorizontalLine: (value) => value % 5 == 0,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.white,
          strokeWidth: 0.5,
        ),
        drawVerticalLine: false,
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(fontSize: 10);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('Group ${(value + 1).toInt()}', style: style),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) await refreshState();
  }
}
