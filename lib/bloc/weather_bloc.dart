import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../modals/weather.dart';
import '../modals/weather_map.dart';
import '../modals/errors/error_loading_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial());

  Future<http.Response> weatherResponse(specificUrl, query) async {
    var url = '$specificUrl&q=$query';
    print('Called for Weather API via $specificUrl and query:$query');
    return await http.get(url);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('thrown ServiceNotEnabled Exception');
      throw ServiceNotEnabled(locationServiceErrorMessage);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print('thrown PermissionDenied Exception');
        throw PermissionDenied(permissionDeniedErrorMessage);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print('thrown PermissionDeniedPermanently Exception');
      throw PermissionDeniedPermanently(
          permissionDeniedPermanentlyErrorMessage);
    }

    print('Called Geolocator.getCurrentPosition');
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<WeatherState> yieldWeatherState<T>(
      url, query, Function creator) async {
    try {
      final response = await weatherResponse(url, query);
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      print('FetchCurrentLocationWeather: $responseJson');
      if (response.statusCode >= 400) {
        print(
            'StatusCode: ${response.statusCode}:: ErrorCode: ${responseJson['error']['code']}:: ${response.body}');
        print('thrown Exception: WeatherLoadingException');
        throw ErrorLoadingWeather(
          response.statusCode,
          responseJson['error']['code'],
        );
      }
      final code = responseJson['current']['condition']['code'];
      print('yielded CurrentWeather');
      return creator(
        weatherData: WeatherData.fromJson(responseJson),
        iconNo: WeatherMap.weatherInfo[code]['icon'],
      );
    // } on ErrorLoadingWeather catch (error) {
    //   print('yielded CurrentWeather with Exception:WeatherException');
    //   // return creator(error: error);
    //   return WeatherExceptionState(error);
    // } on WeatherException catch (error) {
    //   print('yielded CurrentWeather with Exception:WeatherException');
    //   throw error;
    } catch (error) {
      print('yielded WeatherExceptionState with ${error.toString()}');
      // return creator(error: error);
      return WeatherExceptionState(error);
    }
  }

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is FetchCurrentLocationWeather) {
      print('yielded LoadingWeather');
      yield LoadingWeather();

      try {
        print('Inside try');
        //get position
        Position position = await _determinePosition(); //.listen((_){})
        print('${position.latitude},${position.longitude}');

        yield await yieldWeatherState(
          currentUrl,
          '${position.latitude},${position.longitude}',
          ({weatherData, iconNo,/* error*/}) => CurrentLocationWeather(
            weatherData: weatherData,
            iconNo: iconNo,
            // error: error,
          ),
        );
      // } on ServiceWeatherException
      }catch (error) {
        print('yielded CurrentLocationWeather with Exception:WeatherException');
        // yield CurrentLocationWeather(error: error);
        yield WeatherExceptionState(error);
      }
    } else if (event is ListLocation) {
      print('yielded WeatherLocation');
      yield WeatherLocationList(null);
    } else if (event is FetchWeather) {
      print('yielded LoadingWeather');
      yield LoadingWeather();
      yield await yieldWeatherState(
        currentUrl,
        event.location,
        ({weatherData, iconNo,/* error*/}) => CurrentWeather(
          weatherData: weatherData,
          iconNo: iconNo,
          // error: error,
        ),
      );
    }
  }
}
