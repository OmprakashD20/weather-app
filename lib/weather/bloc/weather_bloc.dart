import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/weather/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

extension on double {
  double toFahrenheit() => (this * 9 / 5) + 32;
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherInitial()) {
    on<WeatherRequested>(_onFetchWeather);
    on<WeatherRefreshRequested>(_onPullRefresh);
    on<WeatherTemperatureToggled>(_onTemperatureToggled);
  }

  double convertTemperature(double temperature, TemperatureUnits unit) {
    return unit.isFarenheit ? temperature.toFahrenheit() : temperature;
  }

  void _onFetchWeather(
      WeatherRequested event, Emitter<WeatherState> emit) async {
    String city = event.city;

    if (city.isEmpty) {
      return emit(
        WeatherError(
          message: "Enter the city name to fetch the weather",
          temperatureUnits: state.temperatureUnits,
        ),
      );
    }

    emit(WeatherLoading(
      temperatureUnits: state.temperatureUnits,
    ));

    try {
      final weather =
          Weather.fromRepository(await _weatherRepository.fetchWeather(city));

      final unit = state.temperatureUnits;
      final temperature = convertTemperature(weather.temperature.value, unit);

      final maxTemperature =
          convertTemperature(weather.maxTemperature.value, unit);

      final minTemperature =
          convertTemperature(weather.minTemperature.value, unit);
      print("hi");
      emit(
        WeatherLoaded(
          weather: weather.copyWith(
            temperature: Temperature(value: temperature),
            maxTemperature: Temperature(value: maxTemperature),
            minTemperature: Temperature(value: minTemperature),
          ),
          temperatureUnits: unit,
          message: "Fetched weather for $city",
        ),
      );
    } catch (err) {
      emit(WeatherError(
        message: "Cannot fetch data, Try again!!",
        temperatureUnits: state.temperatureUnits,
      ));
    }
  }

  void _onPullRefresh(
      WeatherRefreshRequested event, Emitter<WeatherState> emit) async {
    if (state.weather.location == "-") {
      return emit(WeatherError(
        message: "Try again later!!",
        temperatureUnits: state.temperatureUnits,
      ));
    }

    try {
      final weather = Weather.fromRepository(
        await _weatherRepository.fetchWeather(state.weather.location),
      );

      final unit = state.temperatureUnits;
      final temperature = convertTemperature(weather.temperature.value, unit);

      final maxTemperature =
          convertTemperature(weather.maxTemperature.value, unit);

      final minTemperature =
          convertTemperature(weather.minTemperature.value, unit);

      emit(
        WeatherLoaded(
          weather: weather.copyWith(
            temperature: Temperature(value: temperature),
            maxTemperature: Temperature(value: maxTemperature),
            minTemperature: Temperature(value: minTemperature),
          ),
          temperatureUnits: unit,
          message: "Refreshed city weather",
        ),
      );
    } catch (err) {
      emit(WeatherError(
        message: "Cannot fetch data, Try again!!",
        temperatureUnits: state.temperatureUnits,
      ));
    }
  }

  void _onTemperatureToggled(
      WeatherTemperatureToggled event, Emitter<WeatherState> emit) {
    final unit = event.isToggled
        ? TemperatureUnits.fahrenheit
        : TemperatureUnits.celsius;

    if (state.weather.location == "-") {
      return emit(WeatherError(
        message: "Try again later!!",
        temperatureUnits: state.temperatureUnits,
      ));
    }

    final weather = state.weather;

    final temperature = convertTemperature(weather.temperature.value, unit);

    final maxTemperature =
        convertTemperature(weather.maxTemperature.value, unit);

    final minTemperature =
        convertTemperature(weather.minTemperature.value, unit);

    emit(
      WeatherLoaded(
        weather: weather.copyWith(
          temperature: Temperature(value: temperature),
          maxTemperature: Temperature(value: maxTemperature),
          minTemperature: Temperature(value: minTemperature),
        ),
        temperatureUnits: unit,
        message: "Temperature unit toggled",
      ),
    );
  }
}
