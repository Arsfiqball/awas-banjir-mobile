class SensorRecordData {
  final DateTime recordedAt;
  final double ultrasonic;
  final double power;
  final int waterlevel;

  SensorRecordData({
    this.recordedAt,
    this.ultrasonic,
    this.power,
    this.waterlevel,
  });
}
