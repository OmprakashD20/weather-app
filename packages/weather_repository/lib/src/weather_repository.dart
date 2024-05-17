import 'package:api/api.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart';

class WeatherRepository {
  final ApiClient _apiClient;

  WeatherRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<Weather> fetchWeather(String city) async {
    final location = await _apiClient.getLocationData(location: city);

    final weather = await _apiClient.getWeatherData(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    return Weather(
      location: location.name,
      temperature: weather.temperature,
      condition: weather.weatherCode.toInt().toCondition,
      maxTemperature: weather.maxTemperature,
      minTemperature: weather.minTemperature,
      uvIndexMax: weather.uvIndex,
      rain: weather.rain,
    );
  }
}

extension on int {
  WeatherCondition get toCondition {
    switch (this) {
      case 0:
        return WeatherCondition.clear;
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return WeatherCondition.cloudy;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return WeatherCondition.rainy;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return WeatherCondition.snowy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
