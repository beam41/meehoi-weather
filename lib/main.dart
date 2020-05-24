import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'city_list.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
  // need to set here to override material appBar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: const Color.fromRGBO(0, 0, 0, 0),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Meehoi Weather",
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.grey,
        accentColorBrightness: Brightness.light,
      ),
      home: CityList(),
    );
  }
}
