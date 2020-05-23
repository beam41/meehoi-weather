class Weather {
  final int temp;
  final int humidity;
  final String desc;
  final int time;

  Weather({this.temp, this.humidity, this.desc, this.time});

  factory Weather.fromApiJson(Map<String, dynamic> json) {
    return Weather(
      temp: (json['main']['temp'] - 273.15).round(), // to celcius
      humidity: json['main']['humidity'],
      desc: json['weather'][0]['description'],
      time: json['dt'],
    );
  }
}
