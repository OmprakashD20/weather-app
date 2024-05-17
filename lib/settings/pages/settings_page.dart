import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/weather/bloc/weather_bloc.dart';
import 'package:weather_app/weather/models/weather.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          BlocBuilder<WeatherBloc, WeatherState>(
            buildWhen: (previous, current) =>
                previous.temperatureUnits != current.temperatureUnits,
            builder: (context, state) {
              return ListTile(
                title: const Text('Temperature Units'),
                isThreeLine: true,
                subtitle: const Text(
                  'Use Fahrenheit metric measurements for temperature units.',
                ),
                trailing: Switch(
                  value: state.temperatureUnits.isFarenheit,
                  onChanged: (value) => context
                      .read<WeatherBloc>()
                      .add(WeatherTemperatureToggled(isToggled: value)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
