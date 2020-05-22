class City {
  final int id;
  final String name;
  final String state;
  final String country;
  final Coordinates coord;
  String combiName;

  City({this.id, this.name, this.state, this.country, this.coord});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      country: json['country'],
      coord: Coordinates.fromJson(json['coord']),
    );
  }
}

class Coordinates {
  final double lon;
  final double lat;

  Coordinates({this.lon, this.lat});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lon: json['lon'].toDouble(),
      lat: json['lat'].toDouble(),
    );
  }
}
