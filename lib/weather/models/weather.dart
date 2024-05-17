import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart' as repository;
import 'package:weather_repository/weather_repository.dart' hide Weather;

enum TemperatureUnits { fahrenheit, celsius }

extension Utility on TemperatureUnits {
  bool get isFarenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

class Temperature extends Equatable {
  final double value;

  const Temperature({required this.value});

  @override
  List<Object> get props => [value];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
    };
  }

  factory Temperature.fromMap(Map<String, dynamic> map) {
    return Temperature(
      value: map['value'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Temperature.fromJson(String source) =>
      Temperature.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Weather extends Equatable {
  final String location;
  final Temperature temperature;
  final Temperature maxTemperature;
  final Temperature minTemperature;
  final double uvIndex;
  final double rain;
  final WeatherCondition condition;
  final DateTime lastUpdated;

  const Weather({
    required this.location,
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
    required this.uvIndex,
    required this.rain,
    required this.condition,
    required this.lastUpdated,
  });

  Weather.defaultWeather()
      : location = "-",
        temperature = const Temperature(value: 0),
        maxTemperature = const Temperature(value: 0),
        minTemperature = const Temperature(value: 0),
        uvIndex = 0,
        rain = 0,
        condition = WeatherCondition.unknown,
        lastUpdated = DateTime.now();

  @override
  List<Object> get props => [
        location,
        temperature,
        condition,
        lastUpdated,
        maxTemperature,
        minTemperature,
        uvIndex,
        rain,
      ];

  Weather copyWith({
    String? location,
    Temperature? temperature,
    WeatherCondition? condition,
    DateTime? lastUpdated,
    Temperature? maxTemperature,
    Temperature? minTemperature,
    String? sunrise,
    double? uvIndex,
    double? rain,
  }) {
    return Weather(
      location: location ?? this.location,
      temperature: temperature ?? this.temperature,
      condition: condition ?? this.condition,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      minTemperature: minTemperature ?? this.minTemperature,
      uvIndex: uvIndex ?? this.uvIndex,
      rain: rain ?? this.rain,
    );
  }

  factory Weather.fromRepository(repository.Weather weather) {
    return Weather(
      location: weather.location,
      temperature: Temperature(value: weather.temperature),
      condition: weather.condition,
      lastUpdated: DateTime.now(),
      maxTemperature: Temperature(value: weather.maxTemperature),
      minTemperature: Temperature(value: weather.minTemperature),
      uvIndex: weather.uvIndexMax,
      rain: weather.rain,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location,
      'temperature': temperature.toMap(),
      'condition': condition.toString(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'maxTemperature': maxTemperature.toMap(),
      'minTemperature': minTemperature.toMap(),
      'uvIndex': uvIndex,
      'rain': rain,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      location: map['location'] as String,
      temperature:
          Temperature.fromMap(map['temperature'] as Map<String, dynamic>),
      condition: WeatherCondition.values.firstWhere(
        (element) => element.toString() == map['condition'] as String,
        orElse: () => WeatherCondition.unknown,
      ),
      lastUpdated: DateTime.now(),
      maxTemperature:
          Temperature.fromMap(map['maxTemperature'] as Map<String, dynamic>),
      minTemperature:
          Temperature.fromMap(map['minTemperature'] as Map<String, dynamic>),
      uvIndex: map['uvIndex'] as double,
      rain: map['rain'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source) as Map<String, dynamic>);
}
