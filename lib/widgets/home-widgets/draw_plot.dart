import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DrawPlot extends StatelessWidget {
  final Map<String, dynamic> data;
  final String date;

  final TrackballBehavior? _trackballBehavior = TrackballBehavior(
    enable: true,
    lineType: TrackballLineType.none,
    activationMode: ActivationMode.singleTap,
    tooltipSettings: const InteractiveTooltip(canShowMarker: false),
  );

  DrawPlot({
    Key? key,
    required this.data,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var heartRates = <int>[];

    for (var record in data['heart_rate']) {
      if (record['value'] != null) {
        heartRates.add(record['value']);
      }
    }

    final maxValue = roundToMostSignificantDigit(heartRates.reduce(max)) + 10;
    final minValue = roundToMostSignificantDigit(heartRates.reduce(min)) - 10;

    List<_ChartData> getData() {
      final List<_ChartData> data = <_ChartData>[];
      for (int i = 0; i < heartRates.length; i++) {
        data.add(_ChartData(DateTime(i + 1950), heartRates[i].toDouble()));
      }
      return data;
    }

    List<CartesianSeries<_ChartData, DateTime>> _getLineZoneSeries() {
      return <CartesianSeries<_ChartData, DateTime>>[
        LineSeries<_ChartData, DateTime>(
          animationDuration: 0,
          dataSource: getData(),
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          width: 2,
        ),
      ];
    }

    print('data is ' + heartRates.toString());
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Heart Rate Diagram on $date'),
      primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          intervalType: DateTimeIntervalType.years,
          dateFormat: DateFormat.y(),
          interval: 10000000,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}bpm',
          minimum: maxValue.toDouble(),
          maximum: minValue.toDouble(),
          interval: (maxValue - minValue) / 5,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      series: _getLineZoneSeries(),
      trackballBehavior: _trackballBehavior,
      onTrackballPositionChanging: (TrackballArgs args) {
        args.chartPointInfo.label =
            args.chartPointInfo.header! + ' : ' + args.chartPointInfo.label!;
      },
    );
  }

  int roundToMultiple(int n, int multiple) {
    assert(n >= 0);
    assert(multiple > 0);
    return (n + (multiple ~/ 2)) ~/ multiple * multiple;
  }

  int roundToMostSignificantDigit(int n) {
    assert(n >= 0);
    var numDigits = n.toString().length;
    var magnitude = pow(10, numDigits - 1) as int;
    return roundToMultiple(n, magnitude);
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
