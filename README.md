# Chart It

[![wednesday](https://img.shields.io/badge/Wednesday-4247E8?logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyOSAyOCI+PHBhdGggZmlsbD0iI2ZmZiIgZmlsbC1ydWxlPSJldmVub2RkIiBkPSJNMjMuMDEgMTcuOTVjMCAuNzYtLjM3IDEuNDYtLjk5IDEuODVsLTEuNyAxLjM2Yy0uMTYuMS0uMzYtLjAyLS4zNi0uMjJ2LTguNGEuOTkuOTkgMCAwIDAtLjY3LS45NGwtMi4xLS42N2EuNDMuNDMgMCAwIDAtLjU2LjR2Ny40OWwtMS45OC0yLjQ0YS43LjcgMCAwIDAtLjc1LjAxTDEyIDE4Ljgydi03LjQ1YzAtLjMtLjMtLjUtLjU4LS40bC0xLjkuNzRhMSAxIDAgMCAwLS42Mi45M3Y4LjNjMCAuMi0uMi4zMi0uMzcuMjJMNi44NyAxOS44YTIuMTkgMi4xOSAwIDAgMS0uOTgtMS44NXYtNy4yMmMwLS44Ni40Ny0xLjYzIDEuMjEtMS45OGw2LjM4LTIuOTVjLjUtLjIzIDEuMDgtLjI0IDEuNTktLjAxbDYuNyAyLjk3YTIuMTYgMi4xNiAwIDAgMSAxLjI1IDJ2Ny4xOVptLTYuOTEgNC4zNy0xLjA2LjU0Yy0uNC4yLS44OC4yLTEuMjggMGwtMS4wNi0uNTRjLS4wNiAwLS4wOC0uMS0uMDQtLjE1bDEuNzQtMi4xIDEuNzQgMi4xYy4wNS4wNS4wMi4xNS0uMDQuMTVaTTE0LjUgMGExNCAxNCAwIDEgMCAwIDI4IDE0IDE0IDAgMCAwIDAtMjhaIi8+PC9zdmc+&style=for-the-badge)](https://www.wednesday.is/)
[![pub version](https://img.shields.io/pub/v/chart_it?labelColor=31C4F3&color=389AD5&logo=flutter&logoColor=blue&style=for-the-badge)](https://pub.dev/packages/chart_it)
[![pub likes](https://img.shields.io/pub/likes/chart_it?labelColor=38C1D0&color=45A4B8&label=pub%20likes&style=for-the-badge)](https://pub.dev/packages/chart_it)
[![pub points](https://img.shields.io/pub/points/chart_it?label=pub%20points&labelColor=38C1D0&color=45A4B8&style=for-the-badge)](https://pub.dev/packages/chart_it)
[![license](https://img.shields.io/github/license/wednesday-solutions/chart_it?labelColor=EA4661&color=C13C3A&style=for-the-badge)](https://github.com/wednesday-solutions/chart_it/blob/dev/LICENSE)

Chart_It is a fully written in dart, strongly customizable and seamlessly animated Collection of Charts.

| ![barcharts](https://github.com/wednesday-solutions/chart_it/raw/dev/pub_images/bar-charts-read-me.gif) | ![piecharts](https://github.com/wednesday-solutions/chart_it/raw/dev/pub_images/pie-charts-read-me.gif) |
|:-------------------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------------------:|
|                   [Learn More](https://flutter.wednesday.is/charts/guides/bar-chart)                    |              [Learn More](https://flutter.wednesday.is/charts/guides/pie-and-donut-chart)               |

## Installation
Add the `chart_it` package to your project's `pubspec.yaml` file:
```yaml
dependencies:
  chart_it: ^0.2.2
```
Alternatively, you can also run the following command in your Flutter Project:
```shell
$ flutter pub add chart_it
```

## Documentation
Check out the [complete documentation here](https://flutter.wednesday.is/charts/flutter-charts).

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

## Interactions
Check out the [Interactions Guide](https://flutter.wednesday.is/charts/guides/interactions) to learn more about interaction with `chart_it`.

# License

Flutter Charts is licensed under the BSD-3-Clause license. Check the [LICENSE](https://github.com/wednesday-solutions/chart_it/blob/dev/LICENSE) file for details.
