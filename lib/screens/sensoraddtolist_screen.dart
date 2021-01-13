import 'package:awas_banjir/app_api_service.dart';
import 'package:awas_banjir/widgets/sensor_add_to_list_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sensoritem_screen.dart';

class SensorAddToListScreen extends StatefulWidget {
  const SensorAddToListScreen({
    Key key,
  }) : super(key: key);

  @override
  _SensorAddToListScreenState createState() => _SensorAddToListScreenState();
}

class _SensorAddToListScreenState extends State<SensorAddToListScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final _searchTextFieldController = TextEditingController();
  List<dynamic> _devices = [];
  List<String> _ids = [];
  SharedPreferences _prefs;
  bool _isSearchActive = false;
  String _searchQuery;

  void _updateDeviceList() async {
    final devices = await AppAPIService.getListDevices(search: _searchQuery);

    setState(() {
      _devices = devices;
    });
  }

  @override
  void initState() {
    _updateDeviceList();

    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;

      setState(() {
        _ids = prefs.getStringList('ids') ?? [];
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: _isSearchActive
            ? TextField(
                controller: _searchTextFieldController,
                autofocus: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Masukan pencarian...',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                onEditingComplete: () {
                  setState(() {
                    _searchQuery = _searchTextFieldController.text;
                    _updateDeviceList();
                  });
                },
              )
            : const Text('List Sensor'),
        actions: [
          IconButton(
            icon: FaIcon(
              _isSearchActive ? FontAwesomeIcons.times : FontAwesomeIcons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearchActive = !_isSearchActive;
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: _devices.map((dynamic device) {
          return SensorAddToListItem(
            id: device['_id'],
            name: device['name'],
            description: device['description'],
            addable: _ids.contains(device['_id']) == false,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/sensor',
                arguments: SensorItemScreenArguments(id: device['_id']),
              );
            },
            onPressed: () async {
              List<String> ids = _prefs.getStringList('ids') ?? [];
              ids.add(device['_id']);
              await _prefs.setStringList('ids', ids);
              firebaseMessaging.subscribeToTopic('sensor_${device['_id']}');

              setState(() {
                _ids.add(device['_id']);
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
