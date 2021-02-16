
import 'package:WeatherApp/constants.dart';

class WeatherException implements Exception{ }

class ErrorLoadingWeather extends WeatherException {
  final int statusCode;
  final int errorCode;
  ErrorLoadingWeather(this.statusCode, this.errorCode);
}

class ServiceWeatherException extends WeatherException{
  final String message;
  ServiceWeatherException(this.message);
  @override
  String toString() {
    if (message == null) return defaultServiceWeatherExceptionMessage;
    return "$message";
  }
}

class ServiceNotEnabled extends ServiceWeatherException {
  ServiceNotEnabled(message):super(message);
}

class PermissionDenied extends ServiceWeatherException {
  PermissionDenied(message):super(message);
}

class PermissionDeniedPermanently extends ServiceWeatherException {
  PermissionDeniedPermanently(message):super(message);
}
