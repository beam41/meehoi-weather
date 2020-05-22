import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'show_weather.dart';

import 'city_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Meehoi Weather",
        home: CityList(),
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.grey,
          accentColorBrightness: Brightness.light,
        ));
  }
}
