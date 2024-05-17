part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  final Weather weather;
  final TemperatureUnits temperatureUnits;

  const WeatherState({
    required this.weather,
    required this.temperatureUnits,
  });

  @override
  List<Object> get props => [weather, temperatureUnits];
}

class WeatherInitial extends WeatherState {
  WeatherInitial()
      : super(
          weather: Weather.defaultWeather(),
          temperatureUnits: TemperatureUnits.celsius,
        );
}

class WeatherLoading extends WeatherState {
  WeatherLoading({
    required super.temperatureUnits,
  }) : super(weather: Weather.defaultWeather());
}

class WeatherLoaded extends WeatherState {
  final String message;
  const WeatherLoaded({
    required super.weather,
    required super.temperatureUnits,
    required this.message,
  });
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({
    required this.message,
    required super.temperatureUnits,
  }) : super(weather: Weather.defaultWeather());

  @override
  List<Object> get props => [message];
}
