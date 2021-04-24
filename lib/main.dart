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
  City _city = City('Malaga', 0);
  Future<WeatherResponse> _futureWeather;

  final mainColor = Color(0xFF2561A0);
  final additionalColor = Colors.white70;
  final textStyleLarge = TextStyle(fontSize: 24, color: Colors.white);
  final textStyleSmall = TextStyle(fontSize: 16, color: Colors.white);
  final defaultPadding = EdgeInsets.all(16);
  final smallPadding = EdgeInsets.all(4);

  @override
  void initState() {
    super.initState();
    _futureWeather = UseCase().loadWeather(_city.name);
  }

  void _updateWeather() {
    setState(() {
      _futureWeather = UseCase().loadWeather(_city.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    _updateWeather();
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
                    Container(
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
                                  '${_city.name}',
                                  style: textStyleSmall,
                                ))
                          ],
                        ))
                  ],
                ),
                Expanded(
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[getWeatherInfo()]))),
              ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateWeather,
        tooltip: 'Update',
        child: Icon(Icons.sync),
      ),
    );
  }

  getWeatherInfo() {
    return FutureBuilder<WeatherResponse>(
      future: _futureWeather,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.current.temp != null) {
          return Column(children: <Widget>[
            Padding(
                padding: defaultPadding,
                child: SvgPicture.asset(
                    'assets/resources/${getWeatherImage(snapshot.data.current.condition)}',
                    height: 60.0)),
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
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }

  String getWeatherImage(Condition condition) {
    var text = condition.text.toLowerCase();
    if (text.contains('snow')) {
      return 'snowy.svg';
    } else if (text.contains('rain')) {
      return 'rainy.svg';
    } else if (text.contains('fog')) {
      return 'fog.svg';
    } else if (text.contains('sun')) {
      return 'sun.svg';
    } else if (text.contains('cloud')) {
      return 'cloud.svg';
    } else {
      return 'cloudy_sunny.svg';
    }
  }
}
