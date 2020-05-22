import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'model/city.dart';

class _CityListState extends State<CityList> {
  Future<List<City>> cityData;
  String filterStr = "";

  @override
  void initState() {
    super.initState();
    cityData = fetchCity();
  }

  Future<List<City>> fetchCity() async {
    String rawData = await DefaultAssetBundle.of(context)
        .loadString("assets/city.list.min.json");
    var jsonData = json.decode(rawData);
    List<City> cityArr = [];
    for (final city in jsonData) {
      var ci = City.fromJson(city);
      if (ci.state == "") {
        ci.combiName = "${ci.name}, ${ci.country}";
      }
      else {
        ci.combiName = "${ci.name}, ${ci.state}, ${ci.country}";
      }

      cityArr.add(ci);
    }
    cityArr.sort((a, b) => a.combiName.compareTo(b.combiName));
    return cityArr;
  }

  Widget _buildList() => Expanded(
      child: Center(
          child: FutureBuilder<List<City>>(
              future: cityData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<City> data = snapshot.data
                      .where((element) => element.combiName.contains(filterStr))
                      .toList();
                  return Scrollbar(
                      child: ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: data.length,
                    itemBuilder: (BuildContext listContext, int index) {
                      return ListTile(
                        title: Text(data[index].combiName),
                      );
                    },
                  ));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return Text("Loading..");
              })));

  Widget _buildSearch() => Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400], width: 1)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700], width: 1)),
          labelText: 'Search',
          labelStyle: TextStyle(color: Colors.grey[700]),
          isDense: true,
          contentPadding: EdgeInsets.all(10),
        ),
        cursorColor: Colors.grey[900],
        textInputAction: TextInputAction.search,
        onChanged: (text) {
          setState(() {
            filterStr = text;
          });
        },
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("City"),
        ),
        body: Column(
          children: <Widget>[_buildSearch(), _buildList()],
        ));
  }
}

class CityList extends StatefulWidget {
  @override
  _CityListState createState() => _CityListState();
}