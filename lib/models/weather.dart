class Weather {
  final int temp;
  final int humidity;
  final String desc;

  Weather({this.temp, this.humidity, this.desc});

  factory Weather.fromApiJson(Map<String, dynamic> json) {
    return Weather(
      temp: (json['main']['temp'] - 273.15).round(), // to celcius
      humidity: json['main']['humidity'],
      desc: json['weather'][0]['description'],
    );
  }
}
