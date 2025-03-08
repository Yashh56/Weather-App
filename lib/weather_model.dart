class Weather {
  final Location location;
  final Current current;
  final Forecast forecast;

  Weather({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
      forecast: Forecast.fromJson(json['forecast']),
    );
  }
}

class Location {
  final String name;
  final String country;

  Location({required this.name, required this.country});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      country: json['country'],
    );
  }
}

class Current {
  final double tempC;
  final Condition condition;

  Current({required this.tempC, required this.condition});

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: json['temp_c'].toDouble(),
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Condition {
  final String text;

  Condition({required this.text});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
    );
  }
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      forecastday: (json['forecastday'] as List)
          .map((day) => ForecastDay.fromJson(day))
          .toList(),
    );
  }
}

class ForecastDay {
  final List<Hour> hour;

  ForecastDay({required this.hour});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      hour: (json['hour'] as List).map((h) => Hour.fromJson(h)).toList(),
    );
  }
}

class Hour {
  final int timeEpoch;
  final double tempC;
  final Condition condition;
  final double chanceOfRain;

  Hour({
    required this.timeEpoch,
    required this.tempC,
    required this.condition,
    required this.chanceOfRain,
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      timeEpoch: json['time_epoch'],
      tempC: json['temp_c'].toDouble(),
      condition: Condition.fromJson(json['condition']),
      chanceOfRain: json['chance_of_rain'].toDouble(),
    );
  }
}
