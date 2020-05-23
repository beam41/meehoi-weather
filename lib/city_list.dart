import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'models/city.dart';
import 'show_weather.dart';

class _CityListState extends State<CityList> {
  List<City> _cityData;
  String _searchString = "";
  bool _fetching = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetching = true;
    });
    _fetchCity().then((value) {
      // prevent late data
      if (_searchString == value['str']) {
        _cityData = value['array'];
        setState(() {
        _fetching = false;
      });
      }
    });
  }

  Future<Map> _fetchCity() async {
    final search = _searchString;
    final response = await http.get(
      "https://mee-weather.azurewebsites.net/api/GetCityList?code=${DotEnv().env['AZURE_KEY']}&q=$search",
    );
    if (response.statusCode == 200) {
      var js = json.decode(response.body);
      List<City> cityArr = [];
      for (final city in js) {
        cityArr.add(City.fromJson(city));
      }
      return {'str': search, 'array': cityArr};
    } else if (response.statusCode == 403) {
      return {'str': search, 'array': new List<City>()};
    } else {
      throw Exception('Failed to load API');
    }
  }

  Widget _listBuilder() {
    if (!_fetching) {
      if (_cityData.length > 0) {
        return Scrollbar(
          child: ListView.builder(
            padding: EdgeInsets.only(left: 16.0),
            itemCount: _cityData.length,
            itemBuilder: (BuildContext listContext, int index) {
              return ListTile(
                title: Text(_cityData[index].name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowWeather(
                        _cityData[index].id,
                        _cityData[index].name,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      }
      return Text(
        "Try Searching${_searchString.length > 0 ? ' again' : '!'}",
        style: TextStyle(color: Colors.grey),
      );
    }
    // By default, show a loading spinner.
    return CircularProgressIndicator();
  }

  Widget _buildList() => Expanded(
        child: Center(
          child: _listBuilder(),
        ),
      );

  Widget _buildSearch() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: TextField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400], width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700], width: 1),
            ),
            labelText: 'Search',
            labelStyle: TextStyle(color: Colors.grey[700]),
            isDense: true,
            contentPadding: EdgeInsets.all(10),
          ),
          cursorColor: Colors.grey[900],
          textInputAction: TextInputAction.search,
          onChanged: (text) {
            _searchString = text;
            setState(() {
              _fetching = true;
            });
            _fetchCity().then((value) {
              // prevent late data
              if (_searchString == value['str']) {
                _cityData = value['array'];
                setState(() {
                  _fetching = false;
                });
              }
            });
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("City"),
      ),
      body: Column(
        children: <Widget>[_buildSearch(), _buildList()],
      ),
    );
  }
}

class CityList extends StatefulWidget {
  @override
  _CityListState createState() => _CityListState();
}
