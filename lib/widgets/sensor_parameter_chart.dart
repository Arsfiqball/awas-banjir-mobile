import 'package:awas_banjir/entities/sensor_record_data.dart';
import 'package:awas_banjir/widgets/simple_time_series_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SensorParameterChart extends StatelessWidget {
  final String title;
  final DateTime Function(SensorRecordData, int) domainFn;
  final num Function(SensorRecordData, int) measureFn;
  final bool isAllInt;
  final String value;

  const SensorParameterChart({
    Key key,
    @required this.records,
    @required this.title,
    @required this.domainFn,
    @required this.measureFn,
    this.isAllInt = false,
    this.value = '',
  }) : super(key: key);

  final List<SensorRecordData> records;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 5,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(value),
              ),
            ],
          ),
          Container(
            height: 140,
            child: SimpleTimeSeriesChart(
              [
                new charts.Series<SensorRecordData, DateTime>(
                  id: title,
                  colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                  domainFn: domainFn,
                  measureFn: measureFn,
                  data: records,
                ),
              ],
              isAllInt: isAllInt,
            ),
          ),
        ],
      ),
    );
  }
}