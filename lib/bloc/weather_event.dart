part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {
  final String location;
  WeatherEvent(this.location);
}

class ListLocation extends WeatherEvent {
  ListLocation(location) : super(location);
}

class FetchWeather extends WeatherEvent {
  FetchWeather(location) : super(location);
}

class FetchCurrentLocationWeather extends WeatherEvent {
  FetchCurrentLocationWeather() : super(null);
}

// class FetchingWeather extends WeatherEvent {
//   FetchingWeather(location) : super(location);
// }
