import 'package:awas_banjir/entities/sensor_record_data.dart';

class SensorData {
  final String id;
  final String name;
  final String description;
  final SensorRecordData lastRecorded;
  final List<SensorRecordData> records;

  SensorData({
    this.id,
    this.name,
    this.description,
    this.lastRecorded,
    this.records,
  });
}
