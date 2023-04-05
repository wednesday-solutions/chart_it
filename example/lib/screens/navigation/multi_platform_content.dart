import 'package:example/place_holder/benchmark.dart';
import 'package:example/place_holder/test_bar_chart.dart';
import 'package:example/place_holder/test_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MultiPlatformContent extends StatefulWidget {
  final isTestMode;

  const MultiPlatformContent({
    Key? key,
    required this.isTestMode,
  }) : super(key: key);

  @override
  State<MultiPlatformContent> createState() => _MultiPlatformContentState();
}

class _MultiPlatformContentState extends State<MultiPlatformContent> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // For mobile devices, we can directly have a navigation drawer
      // drawer: Device.isMobile ? _getDrawer() : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          switch (_currentIndex) {
            case 0:
              return const TestBarChart();
            case 1:
              {
                if (widget.isTestMode) {
                  return const BenchmarkSample();
                } else {
                  return const TestPieChart();
                }
              }
            case 2:
              return const TestPieChart();
            default:
              return const Text('No Page Found');
          }
        },
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: List.generate(widget.isTestMode ? 3 : 2, (index) {
          if (index == 0) {
            return SalomonBottomBarItem(
              icon: const Icon(Icons.bar_chart_rounded),
              title: const Text("Bar Chart"),
              selectedColor: const Color(0xFF191FC8),
            );
          }
          if (index == 1 && widget.isTestMode) {
            return SalomonBottomBarItem(
              icon: const Icon(Icons.speed),
              title: const Text("BenchMark"),
              selectedColor: const Color(0xFF191FC8),
            );
          } else {
            return SalomonBottomBarItem(
              icon: const Icon(Icons.pie_chart_outline),
              title: const Text("Pie Chart"),
              selectedColor: const Color(0xFF191FC8),
            );
          }
        }),
      ),
    );
  }
}
