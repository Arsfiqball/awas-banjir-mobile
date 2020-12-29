import 'package:awas_banjir/entities/sensor_record_data.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series<SensorRecordData, DateTime>> seriesList;
  final bool animate;
  final bool isAllInt;

  SimpleTimeSeriesChart(
    this.seriesList, {
    this.animate = false,
    this.isAllInt = false,
  });

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
          dataIsInWholeNumbers: isAllInt,
          desiredTickCount: 5,
        ),
      ),
      domainAxis: new charts.DateTimeAxisSpec(
        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          minute: new charts.TimeFormatterSpec(
            format: 'HH:mm',
            transitionFormat: 'HH:mm',
          ),
          hour: new charts.TimeFormatterSpec(
            format: 'HH:mm',
            transitionFormat: 'HH:mm',
          ),
          day: new charts.TimeFormatterSpec(
            format: 'dd/MM/yyyy',
            transitionFormat: 'dd/MM/yyyy',
          ),
        ),
      ),
    );
  }
}
