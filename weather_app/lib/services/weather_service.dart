import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const apiKey = 'f1d9ec18731b3151e2217e50b899586f';

  static Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
