import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchWeatherData() async {
  final response = {
    "request": {
      "type": "City",
      "query": "Franca, Brazil",
      "language": "en",
      "unit": "m"
    },
    "location": {
      "name": "Franca",
      "country": "Brazil",
      "region": "Sao Paulo",
      "lat": "-20.533",
      "lon": "-47.400",
      "timezone_id": "America/Sao_Paulo",
      "localtime": "2025-04-29 23:10",
      "localtime_epoch": 1745968200,
      "utc_offset": "-3.0"
    },
    "current": {
      "observation_time": "02:10 AM",
      "temperature": 18,
      "weather_code": 116,
      "weather_icons": [
        "https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"
      ],
      "weather_descriptions": [
        "Partly Cloudy "
      ],
      "astro": {
        "sunrise": "06:25 AM",
        "sunset": "05:48 PM",
        "moonrise": "08:20 AM",
        "moonset": "07:23 PM",
        "moon_phase": "Waxing Crescent",
        "moon_illumination": 2
      },
      "air_quality": {
        "co": "312.65",
        "no2": "14.06",
        "o3": "53",
        "so2": "2.775",
        "pm2_5": "21.275",
        "pm10": "21.275",
        "us-epa-index": "2",
        "gb-defra-index": "2"
      },
      "wind_speed": 6,
      "wind_degree": 120,
      "wind_dir": "ESE",
      "pressure": 1014,
      "precip": 0,
      "humidity": 93,
      "cloudcover": 27,
      "feelslike": 18,
      "uv_index": 0,
      "visibility": 10,
      "is_day": "no"
    }
  };
  // final response = await http.get(Uri.parse('http://api.weatherstack.com/current?access_key=39716a7dd5b23bf7acaf7f2ab17f996c&query=Franca,%20São%20Paulo'));

  return response;

  // if(response.statusCode == 200) {
  //   return Map<String, dynamic>.from(json.decode(response.body));
  // } else {
  //   throw Exception('Failed to load weather data');
  // }
}

class WeatherStatusPage extends StatefulWidget {
  WeatherStatusPage({Key? key}) : super(key: key);

  @override
  _WeatherStatusPageState createState() => _WeatherStatusPageState();
}

class _WeatherStatusPageState extends State<WeatherStatusPage> {
  late Future<Map<String, dynamic>> futureWeatherData;

  @override
  void initState() {
    super.initState();
    futureWeatherData = fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Franca Weather'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: futureWeatherData,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location: ${snapshot.data!['location']['name']}, ${snapshot.data!['location']['country']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Temperature: ${snapshot.data!['current']['temperature']}°C',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Weather: ${snapshot.data!['current']['weather_descriptions'][0]}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Wind Speed: ${snapshot.data!['current']['wind_speed']} km/h',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Humidity: ${snapshot.data!['current']['humidity']}%',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            }

            if(snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );

            }
            return const CircularProgressIndicator();
          }
        )
      ),
    );
  }
}