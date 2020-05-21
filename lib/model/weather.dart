class Weather {
  final String city;
  final int temp;

  Weather({this.city, this.temp});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['city'],
      temp: json['temp'],
    );
  }
}
