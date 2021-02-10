import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:geolocator/geolocator.dart';

import '../utils/enable_gps_alert.dart';
import '../utils/enable_permission_alert.dart';
import '../modals/errors/error_loading_weather.dart';
import '../bloc/weather_bloc.dart';

class WeatherScreen extends StatelessWidget {
  static const routeName = '/';

  Widget _showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget element(String text, TextStyle style, [maxline = 2]) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SizedBox(
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          style: style,
          softWrap: true,
          maxLines: maxline,
        ),
      ),
    );
  }

  Widget _showWeatherInfo(WeatherState state) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/weather/64x64/${state.weatherData.isDay == 1 ? 'day' : 'night'}/${state.iconNo}.png',
              ),
              Flexible(
                child: element(
                  state.weatherData.conditionText,
                  TextStyle(fontSize: 40),
                ),
              ),
            ],
          ),
        ),
        element(
          '${state.weatherData.tempC} \u2103',
          TextStyle(fontSize: 80),
        ),
        element(
          'Humidity: ${state.weatherData.humidity}%',
          TextStyle(fontSize: 25),
        ),
        element(
          'Wind Speed: ${state.weatherData.windKph} Km/h',
          TextStyle(fontSize: 25),
        ),
        element(
          state.weatherData.name,
          TextStyle(fontSize: 50),
        ),
      ],
    );
  }

  Widget _showErrorLoadingIndicator(WeatherState state, BuildContext context) {
    var error;

    if (state.error is ServiceNotEnabled) {
      error = state.error as ServiceNotEnabled;
      return Column(
        children: [
          element(
            error.toString(),
            TextStyle(fontSize: 30),
          ),
          FlatButton(
              child: Text('Try Again',style: TextStyle(fontSize: 20),),
              // elevation: 5,
              textColor: Colors.blue,
              onPressed: () => BlocProvider.of<WeatherBloc>(context)
                  .add(FetchCurrentLocationWeather())),
        ],
      );
    } else if (state.error is PermissionDenied) {
      error = state.error as PermissionDenied;
      return element(
        error.toString(),
        TextStyle(fontSize: 30),
      );
    } else if (state.error is PermissionDeniedPermanently) {
      error = state.error as PermissionDeniedPermanently;
      return element(
        error.toString(),
        TextStyle(fontSize: 30),
      );
    }

    if (state.error is ErrorLoadingWeather)
      error = state.error as ErrorLoadingWeather;
    else {
      return element(
        'Unknown Error! Check Internet Connection, Permission for GPS and turn On GPS. ',
        TextStyle(fontSize: 40),
        4,
      );
      // throw Exception('Unknown Exception encountered!');
    }
    print(error.errorCode);

    if (error.statusCode == 401 && error.errorCode == 1002) {
      return element(
        'API key not provided.',
        TextStyle(fontSize: 30),
      );
    } else if (error.statusCode == 400 && error.errorCode == 1003) {
      return element(
        "Proper Query not provided",
        TextStyle(fontSize: 30),
      );
    } else if (error.statusCode == 400 && error.errorCode == 1005) {
      return element(
        "API request url is invalid",
        TextStyle(fontSize: 30),
      );
    } else if (error.statusCode == 400 && error.errorCode == 1006) {
      return element(
        'No matching location found',
        TextStyle(fontSize: 30),
      );
    } else if (error.statusCode == 401 && error.errorCode == 2006) {
      return element(
        'API key provided is invalid',
        TextStyle(fontSize: 30),
      );
    } else if (error.statusCode == 403 && error.errorCode == 2007) {
      return element(
        'API key has exceeded calls per month quota',
        TextStyle(fontSize: 30),
      );
    } else if (error.statusCode == 403 && error.errorCode == 2008) {
      return element(
        'API key has been disabled',
        TextStyle(fontSize: 30),
      );
    } else if (error.statusCode == 400 && error.errorCode == 9999) {
      return element(
        'Internal application error',
        TextStyle(fontSize: 30),
      );
    }
    return element(
      'Error 404\nSome Unknown Error Occured',
      TextStyle(fontSize: 30),
    );
  }

  void getWeather(
    BuildContext context,
    TextEditingController textController,
    WeatherEvent event,
  ) {
    var location = textController.text.trim();
    if (location != null && location != '')
      BlocProvider.of<WeatherBloc>(context).add(event);
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var locationTextController = TextEditingController();
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: BlocProvider<WeatherBloc>(
        create: (context) => WeatherBloc()..add(FetchCurrentLocationWeather()),
        child: Builder(
          builder: (context) => BlocConsumer<WeatherBloc, WeatherState>(
            cubit: BlocProvider.of<WeatherBloc>(
                context), //will give error as this context does not have a bloc
            listener: (BuildContext context, WeatherState state) {
              if (state.error != null && state.error is ServiceNotEnabled) {
                if (state.error is ServiceNotEnabled) {
                  showEnableGPSDialoge(context);
                  // if(await Geolocator.isLocationServiceEnabled())
                  //   BlocProvider.of<WeatherBloc>(context).add(FetchCurrentLocationWeather());
                  // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Trial')));
                } else if (state.error is PermissionDenied ||
                    state.error is PermissionDeniedPermanently) {
                  showEnablePermissionDialogue('Give GPS Permission', context);
                }
                // else if (state.error is PermissionDeniedPermanently) {
                //   showEnablePermissionDialogue('Give GPS Permission', context);
                // }
              }
            },
            builder: (BuildContext context, WeatherState state) {
              if (state is LoadingWeather) return _showLoadingIndicator();

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.error != null)
                      _showErrorLoadingIndicator(state, context),
                    if (state.error == null &&
                        (state is CurrentWeather ||
                            state is CurrentLocationWeather))
                      _showWeatherInfo(state),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("Location:"),
                            TextField(
                              textInputAction: TextInputAction.done,
                              controller: locationTextController,
                              decoration: InputDecoration(
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.my_location),
                                      onPressed: () => BlocProvider.of<
                                              WeatherBloc>(context)
                                          .add(FetchCurrentLocationWeather()),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () => getWeather(
                                        context,
                                        locationTextController,
                                        FetchWeather(
                                          locationTextController.text,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onSubmitted: (location) => getWeather(
                                context,
                                locationTextController,
                                FetchWeather(locationTextController.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
