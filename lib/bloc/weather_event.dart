part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {
  final String location;
  WeatherEvent(this.location);
}

class Listlocation extends WeatherEvent {
  Listlocation(location) : super(location);
}

class FetchWeather extends WeatherEvent {
  FetchWeather(location) : super(location);
}

// class FetchingWeather extends WeatherEvent {
//   FetchingWeather(location) : super(location);
// }
