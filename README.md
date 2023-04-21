# Chart It

Chart_It is a fully written in dart, strongly customizable and seamlessly animated Collection of Charts.

[![pub version](https://img.shields.io/badge/pub-v0.0.5-blue?style=for-the-badge&logo=flutter)]()
[![made with](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxODQuNzEiIGhlaWdodD0iMzUiIHZpZXdCb3g9IjAgMCAxODQuNzEgMzUiPjxyZWN0IGNsYXNzPSJzdmdfX3JlY3QiIHg9IjAiIHk9IjAiIHdpZHRoPSIxMTUuMzEiIGhlaWdodD0iMzUiIGZpbGw9IiMzMUM0RjMiLz48cmVjdCBjbGFzcz0ic3ZnX19yZWN0IiB4PSIxMTMuMzEiIHk9IjAiIHdpZHRoPSI3MS40IiBoZWlnaHQ9IjM1IiBmaWxsPSIjMzg5QUQ1Ii8+PHBhdGggY2xhc3M9InN2Z19fdGV4dCIgZD0iTTE1LjY5IDIyTDE0LjIyIDIyTDE0LjIyIDEzLjQ3TDE2LjE0IDEzLjQ3TDE4LjYwIDIwLjAxTDIxLjA2IDEzLjQ3TDIyLjk3IDEzLjQ3TDIyLjk3IDIyTDIxLjQ5IDIyTDIxLjQ5IDE5LjE5TDIxLjY0IDE1LjQzTDE5LjEyIDIyTDE4LjA2IDIyTDE1LjU1IDE1LjQzTDE1LjY5IDE5LjE5TDE1LjY5IDIyWk0yOC40OSAyMkwyNi45NSAyMkwzMC4xNyAxMy40N0wzMS41MCAxMy40N0wzNC43MyAyMkwzMy4xOCAyMkwzMi40OSAyMC4wMUwyOS4xOCAyMC4wMUwyOC40OSAyMlpNMzAuODMgMTUuMjhMMjkuNjAgMTguODJMMzIuMDcgMTguODJMMzAuODMgMTUuMjhaTTQxLjE0IDIyTDM4LjY5IDIyTDM4LjY5IDEzLjQ3TDQxLjIxIDEzLjQ3UTQyLjM0IDEzLjQ3IDQzLjIxIDEzLjk3UTQ0LjA5IDE0LjQ4IDQ0LjU3IDE1LjQwUTQ1LjA1IDE2LjMzIDQ1LjA1IDE3LjUyTDQ1LjA1IDE3LjUyTDQ1LjA1IDE3Ljk1UTQ1LjA1IDE5LjE2IDQ0LjU3IDIwLjA4UTQ0LjA4IDIxLjAwIDQzLjE5IDIxLjUwUTQyLjMwIDIyIDQxLjE0IDIyTDQxLjE0IDIyWk00MC4xNyAxNC42Nkw0MC4xNyAyMC44Mkw0MS4xNCAyMC44MlE0Mi4zMCAyMC44MiA0Mi45MyAyMC4wOVE0My41NSAxOS4zNiA0My41NiAxNy45OUw0My41NiAxNy45OUw0My41NiAxNy41MlE0My41NiAxNi4xMyA0Mi45NiAxNS40MFE0Mi4zNSAxNC42NiA0MS4yMSAxNC42Nkw0MS4yMSAxNC42Nkw0MC4xNyAxNC42NlpNNTUuMDkgMjJMNDkuNTEgMjJMNDkuNTEgMTMuNDdMNTUuMDUgMTMuNDdMNTUuMDUgMTQuNjZMNTEuMDAgMTQuNjZMNTEuMDAgMTcuMDJMNTQuNTAgMTcuMDJMNTQuNTAgMTguMTlMNTEuMDAgMTguMTlMNTEuMDAgMjAuODJMNTUuMDkgMjAuODJMNTUuMDkgMjJaTTY2LjY1IDIyTDY0LjY4IDEzLjQ3TDY2LjE1IDEzLjQ3TDY3LjQ3IDE5Ljg4TDY5LjEwIDEzLjQ3TDcwLjM0IDEzLjQ3TDcxLjk2IDE5Ljg5TDczLjI3IDEzLjQ3TDc0Ljc0IDEzLjQ3TDcyLjc3IDIyTDcxLjM1IDIyTDY5LjczIDE1Ljc3TDY4LjA3IDIyTDY2LjY1IDIyWk04MC4zOCAyMkw3OC45MCAyMkw3OC45MCAxMy40N0w4MC4zOCAxMy40N0w4MC4zOCAyMlpNODYuODcgMTQuNjZMODQuMjMgMTQuNjZMODQuMjMgMTMuNDdMOTEuMDAgMTMuNDdMOTEuMDAgMTQuNjZMODguMzQgMTQuNjZMODguMzQgMjJMODYuODcgMjJMODYuODcgMTQuNjZaTTk2LjI0IDIyTDk0Ljc1IDIyTDk0Ljc1IDEzLjQ3TDk2LjI0IDEzLjQ3TDk2LjI0IDE3LjAyTDEwMC4wNSAxNy4wMkwxMDAuMDUgMTMuNDdMMTAxLjUzIDEzLjQ3TDEwMS41MyAyMkwxMDAuMDUgMjJMMTAwLjA1IDE4LjIxTDk2LjI0IDE4LjIxTDk2LjI0IDIyWiIgZmlsbD0iI0ZGRkZGRiIvPjxwYXRoIGNsYXNzPSJzdmdfX3RleHQiIGQ9Ik0xMzEuNDcgMjJMMTI3LjUwIDIyTDEyNy41MCAxMy42MEwxMzEuNDcgMTMuNjBRMTMyLjg1IDEzLjYwIDEzMy45MiAxNC4xMlExMzQuOTkgMTQuNjMgMTM1LjU4IDE1LjU4UTEzNi4xNiAxNi41MyAxMzYuMTYgMTcuODBMMTM2LjE2IDE3LjgwUTEzNi4xNiAxOS4wNyAxMzUuNTggMjAuMDJRMTM0Ljk5IDIwLjk3IDEzMy45MiAyMS40OFExMzIuODUgMjIgMTMxLjQ3IDIyTDEzMS40NyAyMlpNMTI5Ljg4IDE1LjUwTDEyOS44OCAyMC4xMEwxMzEuMzggMjAuMTBRMTMyLjQ1IDIwLjEwIDEzMy4xMSAxOS40OVExMzMuNzYgMTguODggMTMzLjc2IDE3LjgwTDEzMy43NiAxNy44MFExMzMuNzYgMTYuNzIgMTMzLjExIDE2LjExUTEzMi40NSAxNS41MCAxMzEuMzggMTUuNTBMMTMxLjM4IDE1LjUwTDEyOS44OCAxNS41MFpNMTQyLjMxIDIyTDEzOS44OCAyMkwxNDMuNTkgMTMuNjBMMTQ1Ljk0IDEzLjYwTDE0OS42NSAyMkwxNDcuMTkgMjJMMTQ2LjUyIDIwLjM3TDE0Mi45NyAyMC4zN0wxNDIuMzEgMjJaTTE0NC43NSAxNS45M0wxNDMuNjYgMTguNjFMMTQ1LjgzIDE4LjYxTDE0NC43NSAxNS45M1pNMTU2LjE5IDIyTDE1My44MSAyMkwxNTMuODEgMTMuNjBMMTU3LjY1IDEzLjYwUTE1OC43OSAxMy42MCAxNTkuNjMgMTMuOThRMTYwLjQ3IDE0LjM1IDE2MC45MyAxNS4wNlExNjEuMzggMTUuNzYgMTYxLjM4IDE2LjcxTDE2MS4zOCAxNi43MVExNjEuMzggMTcuNjIgMTYwLjk1IDE4LjMwUTE2MC41MyAxOC45OCAxNTkuNzQgMTkuMzZMMTU5Ljc0IDE5LjM2TDE2MS41NSAyMkwxNTkuMDAgMjJMMTU3LjQ4IDE5Ljc3TDE1Ni4xOSAxOS43N0wxNTYuMTkgMjJaTTE1Ni4xOSAxNS40N0wxNTYuMTkgMTcuOTNMMTU3LjUwIDE3LjkzUTE1OC4yNCAxNy45MyAxNTguNjEgMTcuNjFRMTU4Ljk4IDE3LjI5IDE1OC45OCAxNi43MUwxNTguOTggMTYuNzFRMTU4Ljk4IDE2LjEyIDE1OC42MSAxNS43OVExNTguMjQgMTUuNDcgMTU3LjUwIDE1LjQ3TDE1Ny41MCAxNS40N0wxNTYuMTkgMTUuNDdaTTE2Ny45NiAxNS40OEwxNjUuMzggMTUuNDhMMTY1LjM4IDEzLjYwTDE3Mi45MCAxMy42MEwxNzIuOTAgMTUuNDhMMTcwLjM0IDE1LjQ4TDE3MC4zNCAyMkwxNjcuOTYgMjJMMTY3Ljk2IDE1LjQ4WiIgZmlsbD0iI0ZGRkZGRiIgeD0iMTI2LjMxIi8+PC9zdmc+)](https://forthebadge.com)

|                                               Bar Charts                                                |                                               Pie Charts                                                |
|:-------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------:|
| ![barcharts](https://github.com/wednesday-solutions/chart_it/raw/dev/pub_images/bar-charts-read-me.gif) | ![piecharts](https://github.com/wednesday-solutions/chart_it/raw/dev/pub_images/pie-charts-read-me.gif) |
|                    [Read More](https://flutter.wednesday.is/charts/guides/bar-chart)                    |               [Read More](https://flutter.wednesday.is/charts/guides/pie-and-donut-chart)               |

## Installation
Add the `chart_it` package to your project's `pubspec.yaml` file:
```yaml
dependencies:
  chart_it: ^0.0.4
```
Alternatively, you can also run the following command in your Flutter Project:
```shell
$ flutter pub add chart_it
```

## Supported Charts
All Charts in `chart_it` are categorized in two:

1. Cartesian Charts
   * Bar Chart
   * Multi-Bar Chart
2. Radial Charts
   * Pie Chart
   * Donut Chart

Pick a Chart Widget for the type of Chart you want to draw and provide the necessary data for them.

### Quick Examples:
1. **Bar Charts**
   ```dart
   ...
   import 'package:chart_it/chart_it.dart';
   
   ...
   child: BarChart(
     maxYValue: 50,
     data: BarSeries(  
       barData: <BarGroup>[
         SimpleBar(  
           xValue: 10,  
           label: (value) => 'Group 1',  
           yValue: const BarData(yValue: 25),  
         ),  
         SimpleBar(  
           xValue: 6,  
           label: (value) => 'Group 1',  
           yValue: const BarData(yValue: 12),  
         ),  
         SimpleBar(  
           xValue: 19,  
           label: (value) => 'Group 1',  
           yValue: const BarData(yValue: 38),  
         ),
       ],  
     ),
   ),
   ```
   For Advanced usecases, Check out our Docs [here](https://flutter.wednesday.is/charts/guides/bar-chart).
2. **Donut Charts**
   ```dart
   ...
   import 'package:chart_it/chart_it.dart';
   
   ...
   child: PieChart(
     data: PieSeries(
       donutRadius: 50.0,  
       donutSpaceColor: Colors.white,  
       donutLabel: () => 'Market Shares',
       slices: <SliceData>[
         SliceData(  
           style: const SliceDataStyle(radius: 105.0, color: Colors.red),  
           label: (percent, value) => 'Tesla',  
           value: 34,  
         ),
         SliceData(  
           style: const SliceDataStyle(radius: 90.0, color: Colors.blueGrey),  
           label: (percent, value) => 'Space X',  
           value: 18,  
         ),
         SliceData(  
           style: const SliceDataStyle(radius: 90.0, color: Colors.green),  
           label: (percent, value) => 'Google',  
           value: 42,  
         ),  
         SliceData(  
           style: const SliceDataStyle(radius: 90.0, color: Colors.cyanAccent),  
           label: (percent, value) => 'Microsoft',  
           value: 57,  
         ),
       ],
     ),
   ),
   ```
   For Advanced usecases, Check out our Docs [here](https://flutter.wednesday.is/charts/guides/pie-and-donut-chart).

The **default** animation behaviour for Chart Widgets is it:
- animates when the widget loads for the first time.
- animates for every new data updates.

You can override this behaviour using the `animateOnLoad` and `animateOnUpdate` properties at top level widget.

```dart
...
import 'package:chart_it/chart_it.dart';
	
...
child: BarChart(
  animateOnLoad: false,
  animateOnUpdate: true,
  animationDuration: const Duration(milliseconds: 750),
  data: BarSeries(
  ...
```

All animations in the widget are handled internally. However, if you wish to control your own animation, then you can provide your own custom [AnimationController](https://api.flutter.dev/flutter/animation/AnimationController-class.html) to the top level property `animation`.

```dart
...
import 'package:chart_it/chart_it.dart';
	
...
child: BarChart(
  animation: AnimationController(
    duration: Duration(milliseconds: 500),
    vsync: this, 
  ),
  data: BarSeries(
  ...
```

# License

Flutter Charts is licensed under the BSD-3-Clause license. Check the [LICENSE](https://github.com/wednesday-solutions/flutter-charts/blob/dev/LICENSE) file for details.