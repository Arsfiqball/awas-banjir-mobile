import 'dart:async';
import 'dart:io';

import 'package:awas_banjir/app_api_service.dart';
import 'package:awas_banjir/widgets/sensor_list_item.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sensoritem_screen.dart';

class SensorListScreen extends StatefulWidget {
  const SensorListScreen({
    Key key,
  }) : super(key: key);

  @override
  _SensorListScreenState createState() => _SensorListScreenState();
}

class _SensorListScreenState extends State<SensorListScreen> {
  final _firebaseMessaging = firebaseMessaging;
  final _scaffoldState = GlobalKey<ScaffoldState>();

  SharedPreferences _prefs;
  Timer _refresherTimer;
  List<dynamic> _devices = [];

  Future<void> _loadDeviceList() async {
    List<String> ids = _prefs.getStringList('ids') ?? [];

    if (ids.isEmpty) {
      _devices = [];
      return;
    }

    try {
      final List<dynamic> devices = await AppAPIService.getListDevices(ids: ids);

      setState(() {
        _devices = devices;
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

  Future<void> _handleRefreshData() async {
    await _loadDeviceList();
  }

  String _firebaseMessagingGetDeviceId(Map<String, dynamic> message) {
    String id = '';

    if (Platform.isIOS) {
      id = message['id'];
    } else if (Platform.isAndroid) {
      var data = message['data'];
      id = data['id'];
    }

    return id;
  }

  Future<void> _handleFirebaseMessagingOnMessage(Map<String, dynamic> message) async {
    debugPrint('onMessage: $message');

    final String id = _firebaseMessagingGetDeviceId(message);

    _loadDeviceList();

    _scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text("${message['notification']['title']}"),
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () {
            Navigator.pushNamed(
              _scaffoldState.currentContext,
              '/sensor',
              arguments: SensorItemScreenArguments(id: id),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleFirebaseMessagingOnResume(Map<String, dynamic> message) async {
    debugPrint('onResume: $message');

    final String id = _firebaseMessagingGetDeviceId(message);

    Navigator.pushNamed(
      _scaffoldState.currentContext,
      '/sensor',
      arguments: SensorItemScreenArguments(id: id),
    );
  }

  Future<void> _handleFirebaseMessagingOnLaunch(Map<String, dynamic> message) async {
    debugPrint('onLaunch: $message');

    final String id = _firebaseMessagingGetDeviceId(message);

    Navigator.pushNamed(
      _scaffoldState.currentContext,
      '/sensor',
      arguments: SensorItemScreenArguments(id: id),
    );
  }

  void _configureFirebase() {
    _firebaseMessaging.configure(
      onMessage: _handleFirebaseMessagingOnMessage,
      // onBackgroundMessage: onBackgroundMessage,
      onResume: _handleFirebaseMessagingOnResume,
      onLaunch: _handleFirebaseMessagingOnLaunch,
    );

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: true,
      ),
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
      debugPrint('Settings registered: $settings');
    });
  }

  @override
  void initState() {
    _configureFirebase();

    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;

      _loadDeviceList();
      _refresherTimer = Timer.periodic(new Duration(seconds: 15), (timer) {
        _loadDeviceList();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _refresherTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: const Text('List Sensor'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/add-to-list');
              },
              child: FaIcon(FontAwesomeIcons.plus),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefreshData,
        child: ListView(
          children: _devices.map((dynamic device) {
            final bool hasLastRecord = device.containsKey('last_recorded');

            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/sensor',
                  arguments: SensorItemScreenArguments(id: device['_id']),
                );
              },
              child: SensorListItem(
                name: device['name'],
                description: device['description'],
                ultrasonic: hasLastRecord ? device['last_recorded']['ultrasonic'] + .0 : .0,
                waterlevel: hasLastRecord ? device['last_recorded']['waterlevel'] : 0,
                power: hasLastRecord ? device['last_recorded']['power'] + .0 : 0,
                recordedAt: hasLastRecord ? device['last_recorded']['recorded_at'] : '',
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
