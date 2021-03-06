// import 'package:equatable/equatable.dart';
part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {
  final WeatherData weatherData;
  final int iconNo;
  // final Exception error;
  WeatherState({
    this.weatherData,
    this.iconNo,
    // this.error,
  });
}
//TODO implement location showing list
class WeatherLocationList extends WeatherState {
  WeatherLocationList(weatherData) : super(weatherData: weatherData);
}

class WeatherInitial extends WeatherState {
  WeatherInitial({weatherData, iconNo, error})
      : super(weatherData: weatherData, iconNo: iconNo,);// error: error);
}

class CurrentLocationWeather extends WeatherState {
  CurrentLocationWeather({weatherData, iconNo, error})
      : super(weatherData: weatherData, iconNo: iconNo,);// error: error);
}

class LoadingWeather extends WeatherState {}

class WeatherExceptionState extends WeatherState {
  final Exception error;
  WeatherExceptionState(this.error);
}

class CurrentWeather extends WeatherState {
  CurrentWeather({weatherData, iconNo, error})
      : super(weatherData: weatherData, iconNo: iconNo,);// error: error);
}