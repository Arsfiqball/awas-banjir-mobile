import 'package:awas_banjir/screens/sensoraddtolist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/sensoritem_screen.dart';
import 'screens/sensorlist_screen.dart';

Future<void> main() async {
  await DotEnv().load('.env');

  return runApp(
    MaterialApp(
      title: 'Awas Banjir App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => SensorListScreen());
          case '/add-to-list':
            return MaterialPageRoute(builder: (context) => SensorAddToListScreen());
          case '/sensor':
            final SensorItemScreenArguments args = settings.arguments;
            return MaterialPageRoute(builder: (context) => SensorItemScreen(id: args.id));
        }

        return MaterialPageRoute(builder: (context) => SensorListScreen());
      },
    ),
  );
}
