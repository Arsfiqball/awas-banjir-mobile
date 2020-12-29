import 'dart:async';

import 'package:awas_banjir/app_api_service.dart';
import 'package:awas_banjir/entities/sensor_data.dart';
import 'package:awas_banjir/entities/sensor_record_data.dart';
import 'package:awas_banjir/widgets/sensor_parameter_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorItemScreen extends StatefulWidget {
  final String id;
  const SensorItemScreen({
    Key key,
    this.id,
  }) : super(key: key);

  @override
  _SensorItemScreenState createState() => _SensorItemScreenState();
}

class _SensorItemScreenState extends State<SensorItemScreen> {
  final _scaffoldState = GlobalKey<ScaffoldState>();

  Timer _refresherTimer;
  String _name;
  String _description;
  String _id;
  List<SensorRecordData> _records = [];
  SharedPreferences _prefs;
  String activeGraphTimeOption = 'realtime';

  static const List<Map<String, String>> graphTimeOptions = [
    {'value': 'realtime', 'title': 'Real Time'},
    {'value': '1hour', 'title': '1 Jam'},
    {'value': '2days', 'title': '2 Hari'},
    {'value': '2weeks', 'title': '2 Minggu'},
  ];

  void updateDeviceData() async {
    try {
      final SensorData data = await AppAPIService.getDeviceById(
        widget.id,
        logMode: activeGraphTimeOption,
      );

      if (mounted == false) return;

      setState(() {
        _id = data.id;
        _name = data.name;
        _description = data.description;
        _records = data.records;
      });
    } on AppAPIServiceNetworkError catch (err) {
      print(err);

      if (mounted == false) return;

      _scaffoldState.currentState.showSnackBar(
        SnackBar(
          content: Text("Error saat mengakses jaringan, coba muat ulang!"),
        ),
      );
    }
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });

    updateDeviceData();

    _refresherTimer = Timer.periodic(new Duration(seconds: 15), (timer) {
      if (activeGraphTimeOption == 'realtime') {
        updateDeviceData();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _refresherTimer.cancel();
    super.dispose();
  }

  String transWaterlevel(int w) {
    switch (w) {
      case 1:
        return 'Normal';
        break;
      case 2:
        return 'Siaga';
        break;
      case 3:
        return 'Waspada';
        break;
      case 4:
        return 'Bahaya';
        break;
      default:
        return '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(_name != null ? _name : 'Memuat...'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Apakah anda yakin?'),
                      actions: [
                        FlatButton(
                          onPressed: () async {
                            List<String> ids = _prefs.getStringList('ids');
                            ids.remove(_id);
                            await _prefs.setStringList('ids', ids);
                            firebaseMessaging.unsubscribeFromTopic('sensor_$_id');
                            print('done');
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Ya'),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Tidak'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: FaIcon(FontAwesomeIcons.trash),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(_description != null ? _description : '...'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20),
                child: DropdownButton(
                  value: activeGraphTimeOption,
                  hint: Text('Select'),
                  items: graphTimeOptions
                      .map(
                        (e) => DropdownMenuItem(
                          value: e['value'],
                          child: Text(
                            e['title'],
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      activeGraphTimeOption = value;
                      updateDeviceData();
                    });
                  },
                ),
              ),
            ],
          ),
          SensorParameterChart(
            title: 'Ultrasonic',
            value: "${_records.isNotEmpty ? _records.first.ultrasonic : "?"} cm",
            domainFn: (SensorRecordData record, int _) => record.recordedAt,
            measureFn: (SensorRecordData record, int _) => record.ultrasonic,
            records: _records,
          ),
          SensorParameterChart(
            title: 'Water Level',
            value: _records.isNotEmpty ? transWaterlevel(_records.first.waterlevel) : "?",
            domainFn: (SensorRecordData record, int _) => record.recordedAt,
            measureFn: (SensorRecordData record, int _) => record.waterlevel,
            records: _records,
            isAllInt: true,
          ),
          SensorParameterChart(
            title: 'Power',
            value: "${_records.isNotEmpty ? _records.first.power : "?"} watt",
            domainFn: (SensorRecordData record, int _) => record.recordedAt,
            measureFn: (SensorRecordData record, int _) => record.power,
            records: _records,
          ),
        ],
      ),
    );
  }
}

class SensorItemScreenArguments {
  final String id;
  SensorItemScreenArguments({this.id});
}
