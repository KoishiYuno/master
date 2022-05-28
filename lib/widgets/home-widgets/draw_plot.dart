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

    final maxNumber = heartRates.reduce(max);
    final minNumber = heartRates.reduce(min);
    final maxValue = maxNumber + (10 - maxNumber % 10);
    final minValue = minNumber + (10 - minNumber % 10) - 10;

    List<_ChartData> getData() {
      final List<_ChartData> data = <_ChartData>[];
      if (data.length > 60) {
        for (int i = heartRates.length; i > heartRates.length - 60; i--) {
          data.add(
              _ChartData(DateTime(i + 1950), heartRates[i - 1].toDouble()));
        }
      } else {
        for (int i = 0; i < heartRates.length; i++) {
          data.add(_ChartData(DateTime(i + 1950), heartRates[i].toDouble()));
        }
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
    return Column(
      children: [
        Text(
          'Last 60 HeartRate Records on $date',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.40,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
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
                majorTickLines:
                    const MajorTickLines(color: Colors.transparent)),
            series: _getLineZoneSeries(),
            trackballBehavior: _trackballBehavior,
            onTrackballPositionChanging: (TrackballArgs args) {
              args.chartPointInfo.label = args.chartPointInfo.header! +
                  ' : ' +
                  args.chartPointInfo.label!;
            },
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
