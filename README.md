<!-- TODO: Add Banners Above Here -->
# Chart It

Chart_It is a fully written in dart, strongly customizable and seamlessly animated Collection of Charts.

## Installation
Add the `chart_it` package to your project's `pubspec.yaml` file:
```yaml
dependencies:
  chart_it: ^0.0.2
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
   For Advanced usecases, Check out our Docs [here]().
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
   For Advanced usecases, Check out our Docs [here]().

# License

Flutter Charts is licensed under the BSD-3-Clause license. Check
the [LICENSE](https://github.com/wednesday-solutions/flutter-charts/blob/dev/LICENSE) file for
details.
