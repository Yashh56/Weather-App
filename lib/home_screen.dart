import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_service.dart';
import 'weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  Weather? weather;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
  }

  Future<void> _getCurrentLocationWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      var fetchedWeather = await WeatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      setState(() {
        weather = fetchedWeather;
        errorMessage =
            fetchedWeather == null ? 'Failed to fetch weather data' : '';
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to get location weather: $e";
      });
    }
  }

  Future<void> _searchWeather() async {
    var fetchedWeather =
        await WeatherService.getWeatherByCity(_controller.text);
    setState(() {
      weather = fetchedWeather;
      errorMessage =
          fetchedWeather == null ? 'City not found or API error' : '';
    });
  }

  IconData _getWeatherIcon(String condition) {
    if (condition.toLowerCase().contains('rain')) {
      return Icons.cloudy_snowing;
    } else if (condition.toLowerCase().contains('cloud')) {
      return Icons.cloud;
    } else if (condition.toLowerCase().contains('clear')) {
      return Icons.wb_sunny;
    } else if (condition.toLowerCase().contains('snow')) {
      return Icons.ac_unit;
    } else {
      return Icons.wb_cloudy;
    }
  }

  String _formatLocalTime(int epochTime) {
    DateTime utcTime =
        DateTime.fromMillisecondsSinceEpoch(epochTime * 1000, isUtc: true);
    DateTime localTime = utcTime.toLocal();
    return '${localTime.hour.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.greenAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (weather != null)
                Column(
                  children: [
                    Icon(
                      _getWeatherIcon(weather!.current.condition.text),
                      size: 120,
                      color: Colors.amber,
                    ),
                    Text(
                      '${weather!.location.name}, ${weather!.location.country}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${weather!.current.tempC}°C, ${weather!.current.condition.text}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              const SizedBox(height: 20),
              if (weather != null)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Next 3 Hours Forecast:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: weather!.forecast.forecastday[0].hour
                              .where((hour) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                          hour.timeEpoch * 1000,
                                          isUtc: true)
                                      .toLocal()
                                      .isAfter(DateTime.now()))
                              .take(3)
                              .map((hour) => Container(
                                    margin: const EdgeInsets.all(8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _getWeatherIcon(hour.condition.text),
                                          size: 40,
                                          color: Colors.amber,
                                        ),
                                        Text(
                                          _formatLocalTime(hour.timeEpoch),
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '${hour.tempC}°C',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          hour.condition.text,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Rain: ${hour.chanceOfRain}%',
                                          style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter City',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _searchWeather,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Search Weather',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
