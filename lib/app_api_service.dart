import 'dart:convert';
import 'dart:io';
import 'package:awas_banjir/entities/sensor_data.dart';
import 'package:awas_banjir/entities/sensor_record_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

class AppAPIService {
  static bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  static HttpClient client = new HttpClient()
    ..badCertificateCallback = (_certificateCheck);

  static Future<List<dynamic>> getListDevices({List<String> ids, String search}) async {
    final String _apiBase = DotEnv().env['API_BASE'];
    final String configBaseURI = _apiBase != null ? _apiBase : 'https://awas-banjir.arsfiqball.com';
    String queryIds = ids != null ? ids.map((String id) => "ids=$id").toList().join("&") : '';
    String querySearch = search != null ? 'search=$search' : '';

    String queries =
        '?' + [queryIds, querySearch].where((element) => element != null && element.isNotEmpty).toList().join();

    try {
      final url = '$configBaseURI/device/list$queries';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        final String body = await response.transform(utf8.decoder).join();
        final dynamic data = json.decode(body);
        return List<dynamic>.from(data);
      } else {
        throw new AppAPIServiceNetworkError();
      }
    } catch (err) {
      throw new AppAPIServiceNetworkError();
    }
  }

  static Future<SensorData> getDeviceById(String id, {String logMode = 'realtime'}) async {
    final String _apiBase = DotEnv().env['API_BASE'];
    final String configBaseURI = _apiBase != null ? _apiBase : 'https://awas-banjir.arsfiqball.com';

    try {
      final url = '$configBaseURI/device/$id?with_log=1&log_mode=$logMode';
      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        final String body = await response.transform(utf8.decoder).join();
        final dynamic data = json.decode(body);
        final List<dynamic> dynamicRecords = List<dynamic>.from(data['records']);

        return new SensorData(
          id: data['_id'],
          name: data['name'],
          description: data['description'],
          latitude: data['coordinate']['latitude'] + .0,
          longitude: data['coordinate']['longitude'] + .0,
          records: dynamicRecords
              .map(
                (dynamic record) => new SensorRecordData(
                  recordedAt: DateTime.parse(record['recorded_at']),
                  ultrasonic: record['ultrasonic'] + .0,
                  waterlevel: record['waterlevel'],
                  power: record['power'] + .0,
                ),
              )
              .toList(),
        );
      } else {
        throw new AppAPIServiceNetworkError();
      }
    } catch (err) {
      throw new AppAPIServiceNetworkError();
    }
  }
}

class AppAPIServiceNetworkError implements Exception {
  //
}
