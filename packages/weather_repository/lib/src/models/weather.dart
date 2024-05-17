import 'dart:convert';

import 'package:equatable/equatable.dart';

enum WeatherCondition {
  clear,
  cloudy,
  rainy,
  snowy,
  unknown,
}

class Weather extends Equatable {
  final String location;
  final double temperature;
  final WeatherCondition condition;
  final double maxTemperature;
  final double minTemperature;
  final double uvIndexMax;
  final double rain;

  const Weather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.maxTemperature,
    required this.minTemperature,
    required this.uvIndexMax,
    required this.rain,
  });

  @override
  List<Object?> get props => [
        location,
        temperature,
        condition,
        maxTemperature,
        minTemperature,
        uvIndexMax,
        rain,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location,
      'temperature': temperature,
      'condition': condition.toString(),
      'maxTemperature': maxTemperature,
      'minTemperature': minTemperature,
      'uvIndex': uvIndexMax,
      'rain': rain,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      location: map['location'] as String,
      temperature: map['temperature'] as double,
      maxTemperature: map['maxTemperature'] as double,
      minTemperature: map['minTemperature'] as double,
      uvIndexMax: map['uvIndex'] as double,
      rain: map['rain'] as double,
      condition: WeatherCondition.values.firstWhere(
        (element) => element.toString() == map['condition'] as String,
        orElse: () => WeatherCondition.unknown,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source) as Map<String, dynamic>);
}
