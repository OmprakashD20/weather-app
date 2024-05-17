import 'dart:convert';

class Weather {
  //response from the api - https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true

  // {
  //   "temperature": double,
  //   "weathercode": int,
  //   "daily": {
  //      "temperature_2m_max": "[°C]",
  //      "temperature_2m_min": "[°C]",
  //      "sunrise": "iso8601",
  //      "uv_index_max": "",
  //      "rain_sum": "[mm]"
  //    }
  // }
  final double temperature;
  final double maxTemperature;
  final double minTemperature;
  final double uvIndex;
  final double rain;
  final int weatherCode;

  const Weather({
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.uvIndex,
    required this.rain,
    required this.weatherCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'temperature': temperature,
      'weathercode': weatherCode,
      'maxTemperature': maxTemperature,
      'minTemperature': minTemperature,
      'uvIndex': uvIndex,
      'rain': rain,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      weatherCode: map["current_weather"]['weathercode'] as int,
      temperature: map["current_weather"]['temperature'] as double,
      maxTemperature: map["daily"]['temperature_2m_max'][0] as double,
      minTemperature: map["daily"]['temperature_2m_min'][0] as double,
      rain: map["daily"]['rain_sum'][0] as double,
      uvIndex: map["daily"]['uv_index_max'][0] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source) as Map<String, dynamic>);
}
