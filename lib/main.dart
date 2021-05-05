import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'WeatherApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  City city = City('Malaga', 0);
  Future<WeatherResponse> futureWeather;
  Language language;

  final mainColor = Color(0xFF2561A0);
  final additionalColor = Colors.white70;
  final textStyleLarge = TextStyle(fontSize: 24, color: Colors.white);
  final textStyleSmall = TextStyle(fontSize: 16, color: Colors.white);
  final defaultPadding = EdgeInsets.all(16);
  final smallPadding = EdgeInsets.all(4);

  @override
  void initState() {
    super.initState();
    language = Language.en;
    futureWeather = UseCase().loadWeather(city.name, language);
  }

  void updateWeather() {
    setState(() {
      futureWeather = UseCase().loadWeather(city.name, language);
    });
  }

  void changeLanguage() {
    setState(() {
      if (language == Language.en) {
        language = Language.es;
      } else {
        language = Language.en;
      }
      futureWeather = UseCase().loadWeather(city.name, language);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    // updateWeather();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          color: mainColor,
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child: Container(
                            padding: defaultPadding,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: additionalColor,
                                ),
                                Padding(
                                    padding: smallPadding,
                                    child: Text(
                                      '${city.name}',
                                      style: textStyleSmall,
                                    )),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                            onTap: changeLanguage,
                                            child: Image(
                                                image: AssetImage(
                                                    'assets/resources/' +
                                                        LanguageName[language] +
                                                        '.png'),
                                                height: 32))))
                              ],
                            )))
                  ],
                ),
                Expanded(
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[getWeatherInfo()]))),
              ])),
      floatingActionButton: FloatingActionButton(
        onPressed: updateWeather,
        tooltip: 'Update',
        child: Icon(Icons.sync),
      ),
    );
  }

  getWeatherInfo() {
    return FutureBuilder<WeatherResponse>(
      future: futureWeather,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting &&
            snapshot.hasData &&
            snapshot.data.current.temp != null) {
          return Column(children: <Widget>[
            Padding(
                padding: defaultPadding,
                child: SvgPicture.asset(
                    'assets/resources/${getWeatherImage(snapshot.data.current.condition)}',
                    height: 90.0)),
            Text(
              '+${snapshot.data.current.temp.toInt()}°C',
              style: textStyleLarge,
            ),
            Text(
              '${snapshot.data.current.condition.text}',
              style: textStyleSmall,
            )
          ]);
        } else if (snapshot.hasError) {
          return Padding(
              padding: defaultPadding,
              child: Text('${snapshot.error}', style: textStyleSmall));
        }
        return CircularProgressIndicator();
      },
    );
  }

  String getWeatherImage(Condition condition) {
    var code = condition.code;
    if (code == 1000) {
      return 'sun.svg';
    } else if (code == 1003) {
      return 'cloudy_sunny.svg';
    } else if (code == 1006) {
      return 'cloud.svg';
    } else if (code == 1009) {
      return 'cloud.svg';
    } else if (code == 1030) {
      return 'fog.svg';
    } else if (code == 1063 || code >= 1180 && code <= 1201) {
      return 'rainy.svg';
    } else if (code == 1066 ||
        code == 1069 ||
        code == 1114 ||
        code == 1117 ||
        code >= 1204 && code <= 1237) {
      return 'snowy.svg';
    } else {
      return 'cloudy_sunny.svg';
    }
  }
}
