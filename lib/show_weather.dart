import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'model/weather.dart';

class _ShowWeatherState extends State<ShowWeather> {
  Future<Weather> futureData;
  String cityId = "";

  @override
  void initState() {
    super.initState();
    futureData = fetchWeather();
  }

  Future<Weather> fetchWeather() async {
    final response =
        await http.get("api.openweathermap.org/data/2.5/weather?id=$cityId&appid={your api key}");

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Weather>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(snapshot.data.city),
                  Text("${snapshot.data.temp} °C"),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Text("Loading...");
          }),
    );
  }
}

class ShowWeather extends StatefulWidget {
  @override
  _ShowWeatherState createState() => _ShowWeatherState();
}
