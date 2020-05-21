import 'package:flutter/widgets.dart';
import 'package:meehoiweather/show_weather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: ShowWeather(),
    ));
  }
}
