import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherStatusPage extends StatelessWidget {
  Future<Map<String, dynamic>> fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        'http://api.weatherstack.com/current?access_key=39716a7dd5b23bf7acaf7f2ab17f996c&query=Franca, São Paulo'));

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  final Map<String, dynamic> weatherData;

  const WeatherStatusPage({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: weatherData.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location: ${weatherData['location']['name']}, ${weatherData['location']['country']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Temperature: ${weatherData['current']['temperature']}°C',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Weather: ${weatherData['current']['weather_descriptions'][0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Wind Speed: ${weatherData['current']['wind_speed']} km/h',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Humidity: ${weatherData['current']['humidity']}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            : const Center(
                child: Text(
                  'No weather data available.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}