<!-- TODO: Add Banners Above Here -->

# Flutter Charts

Flutter Charts is a fully written in dart, highly performant Charts Library with Beautifully
Customizable and Animated Charts.

## Installation

Add the `flutter_charts` package to your project's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_charts: ^0.0.1
```

Alternatively, you can also run the following command in your Flutter Project:

```shell
$ flutter pub add flutter_charts
```

## Let's Get Started

All Charts in `flutter_charts` are categorized in two:

1. Cartesian Charts
    * Line Chart (Coming Soon)
    * Bar Chart
    * Candle Stick Chart (Coming Soon)
    * Bubble Chart (Coming Soon)
    * Scatter Chart (Coming Soon)
2. Radial Charts
    * Pie and Donut Chart
    * Radial Bars (Coming Soon)
    * Polar Chart (Coming Soon)
    * Radar Chart (Coming Soon)

Pick a Chart Widget for the type of Chart you want to draw and provide the necessary data for them.

### Quick Examples:

1. **Bar Charts**
   ```dart
   ...
   import 'package:flutter_charts/flutter_charts.dart';
   
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
   For Advanced usecases, Check out our Docs [here]().
2. **Donut Charts**
   ```dart
   ...
   import 'package:flutter_charts/flutter_charts.dart';
   
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
   For Advanced usecases, Check out our Docs [here]().
