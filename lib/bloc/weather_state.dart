part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {
  final WeatherData weatherData;
  final int iconNo;
  WeatherState([this.weatherData, this.iconNo]);
}

class WeatherLocationList extends WeatherState {
  WeatherLocationList(weatherData):super(weatherData);
}

class WeatherInitial extends WeatherState {
  WeatherInitial(weatherData, iconNo):super(weatherData, iconNo);
}

class LoadingWeather extends WeatherState { }

class ErrorLoadingWeather extends WeatherState { 
  final int statusCode;
  final int errorCode;
  ErrorLoadingWeather(this.statusCode, this.errorCode);
}

class CurrentWeather extends WeatherState {
  CurrentWeather(weatherData, iconNo):super(weatherData, iconNo);
}
