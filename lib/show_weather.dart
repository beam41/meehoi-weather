import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'models/weather.dart';
import 'extensions/capitalize.dart';
import 'spinner_reload.dart';

class _ShowWeatherState extends State<ShowWeather> {
  Future<Weather> _futureData;
  int _weatherId;
  bool _fetching = false;
  var _currTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _futureData = _fetchWeather();
  }

  Future<Weather> _fetchWeather() async {
    final response = await http.get(
      "https://api.openweathermap.org/data/2.5/weather?id=${widget.cityId}&appid=${DotEnv().env['API_KEY']}",
    );
    if (response.statusCode == 200) {
      var js = json.decode(response.body);
      setState(() {
        _weatherId = js['weather'][0]['id'];
        _currTime = DateTime.now();
        _fetching = false;
      });
      return Weather.fromApiJson(js);
    } else {
      throw Exception('Failed to load API');
    }
  }

  Color _groupIdColors(int id) {
    // clear and cloud
    if (id == null || id == 800) {
      return Colors.blue;
    }
    if (id > 800) {
      return Colors.blue[500 + (id % 800) * 100];
    }
    // atmosphere
    if (id == 701 && id == 711 && id == 721 && id == 741 && id == 771) {
      return Colors.blueGrey[600];
    }
    if (id == 762 && id == 781) {
      return Colors.grey[900];
    }
    if (id == 731 && id == 751 && id == 761) {
      return Colors.orange[800];
    }
    // thunderstorm
    if (id < 300) {
      return Colors.grey[800];
    }
    // drizzle
    if (id < 400) {
      return Colors.indigo[800];
    }
    // rain
    if (id < 600) {
      return Colors.lightBlue[900];
    }
    // snow
    if (id < 700) {
      return Colors.lightBlue[600];
    }
    return Colors.blue;
  }

  Widget _drawMain(data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                widget.cityNameText,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${data.temp}",
                  style: const TextStyle(
                    fontSize: 200,
                    letterSpacing: -5,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "°C",
                  style: const TextStyle(
                    fontSize: 50,
                    height: 1.4,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              "${data.desc}".capitalize(),
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Humidity: ${data.humidity}%",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(5.0, 0.0),
              child: FlatButton(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                onPressed: () {
                  setState(() {
                    _fetching = true;
                    _futureData = _fetchWeather();
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SpinnerReload(_fetching),
                    ),
                    Text(
                      "updated at: ${DateFormat('d/M/yyyy h:mm').format(_currTime)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _groupIdColors(_weatherId),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: FutureBuilder<Weather>(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _drawMain(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text(
                      "${snapshot.error}",
                      style: const TextStyle(color: Colors.white),
                    );
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator(
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowWeather extends StatefulWidget {
  final int cityId;
  final String cityNameText;

  ShowWeather(this.cityId, this.cityNameText, {Key key}) : super(key: key);

  @override
  _ShowWeatherState createState() => _ShowWeatherState();
}
