part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherRequested extends WeatherEvent {
  final String city;

  WeatherRequested({required this.city});

  @override
  List<Object> get props => [city];
}

class WeatherRefreshRequested extends WeatherEvent {
  final String city;

  WeatherRefreshRequested({required this.city});

  @override
  List<Object> get props => [city];
}

class WeatherTemperatureToggled extends WeatherEvent {
  final bool isToggled;

  WeatherTemperatureToggled({required this.isToggled});

  @override
  List<Object> get props => [isToggled];
}
