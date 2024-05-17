import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:api/api.dart';

class ApiClient {
  final http.Client _httpClient;
  ApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseWeatherApiUrl = 'api.open-meteo.com';
  static const _baseLocationApiUrl = 'geocoding-api.open-meteo.com';

  // Get location data
  Future<Location> getLocationData({required String location}) async {
    final locationRequest = Uri.https(
        _baseLocationApiUrl, 'v1/search', {"name": location, "count": "1"});

    final locationResponse = await _httpClient.get(locationRequest);

    if (locationResponse.statusCode != 200) {
      throw Exception('Failed to get location data');
    }

    final locationJson = jsonDecode(locationResponse.body);

    if (locationJson["results"].isEmpty) {
      throw Exception('Failed to get location data');
    }

    final locationData = jsonEncode(locationJson["results"][0]);

    return Location.fromJson(locationData);
  }

  // Get weather data
  Future<Weather> getWeatherData(
      {required double latitude, required double longitude}) async {
    final weatherRequest = Uri.https(_baseWeatherApiUrl, 'v1/forecast', {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "current_weather": "true",
      "daily":
          "temperature_2m_max,temperature_2m_min,uv_index_max,rain_sum",
    });

    final weatherResponse = await _httpClient.get(weatherRequest);

    if (weatherResponse.statusCode != 200) {
      throw Exception('Failed to get weather data');
    }

    final weatherJson = jsonDecode(weatherResponse.body);

    if (weatherJson["current_weather"].isEmpty ||
        weatherJson["daily"].isEmpty) {
      throw Exception('Failed to get weather data');
    }

    final weatherData = jsonEncode(weatherJson);

    return Weather.fromJson(weatherData);
  }
}
