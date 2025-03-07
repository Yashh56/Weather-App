import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  static const String apiKey = '62d8010662d74867a54110801242505';
  static const String baseUrl = 'http://api.weatherapi.com/v1/forecast.json';

  static Future<Weather?> getWeatherByCity(String city) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl?key=$apiKey&q=$city&days=1'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Weather?> getWeatherByLocation(double lat, double lon) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl?key=$apiKey&q=$lat,$lon&days=1'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
