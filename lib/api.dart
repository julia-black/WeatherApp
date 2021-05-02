import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class UseCase {
  final String api = "api.weatherapi.com";
  final String apiKey = "4828205ef3e64ffdaae144947212404";

  Future<WeatherResponse> loadWeather(
      String cityName, Language language) async {
    var queryParameters = {
      'key': apiKey,
      'q': cityName,
      'aqu': 'no',
      'lang': LanguageName[language]
    };
    Uri uri = Uri.https(api, 'v1/current.json', queryParameters);
    final response = await http.get(uri);

    print("request = ${uri.toString()}");
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return WeatherResponse.fromJson(json);
    } else {
      throw Exception('Failed to loading');
    }
  }
}

class WeatherResponse {
  final CurrentWeather current;

  WeatherResponse({@required this.current});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(current: CurrentWeather.fromJson(json['current']));
  }
}

class CurrentWeather {
  final double temp;
  final Condition condition;

  CurrentWeather({@required this.temp, @required this.condition});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
        temp: json['temp_c'] as double,
        condition: Condition.fromJson(json['condition']));
  }
}

class Condition {
  final int code;
  final String text;

  Condition({@required this.code, @required this.text});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(code: json['code'], text: json['text']);
  }
}

class City {
  String name;
  int id;

  City(this.name, this.id);
}

enum Language { en, es }

const Map<Language, String> LanguageName = {
  Language.en: "en",
  Language.es: "es"
};
