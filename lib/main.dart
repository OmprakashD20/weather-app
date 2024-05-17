import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:weather_app/weather/weather.dart';

void main() {
  runApp(const WeatherAppProviders());
}

class WeatherAppProviders extends StatelessWidget {
  const WeatherAppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(),
      child: Builder(builder: (context) {
        return BlocProvider(
          create: (context) => WeatherBloc(
            weatherRepository: context.read<WeatherRepository>(),
          ),
          child: const WeatherApp(),
        );
      }),
    );
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather App",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
        ),
        textTheme: GoogleFonts.novaFlatTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: const WeatherPage(),
    );
  }
}
