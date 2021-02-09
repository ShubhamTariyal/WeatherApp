import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../modals/errors/error_loading_weather.dart';
import '../bloc/weather_bloc.dart';
import '../widgets/drop_down_search.dart';

class WeatherScreen extends StatelessWidget {
  static const routeName = '/';

  Widget _showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget element(String text, TextStyle style) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SizedBox(
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          style: style,
          softWrap: true,
          maxLines: 2,
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

  Widget _showErrorLoadingIndicator(WeatherState state) {
    var error;

    if (state.error is ServiceWeatherException) {
      error = state.error as ServiceWeatherException;
      return element(
        error,
        TextStyle(fontSize: 30),
      );
    }

    if (state.error is ErrorLoadingWeather)
      error = state.error as ErrorLoadingWeather;
    else
      throw Exception('Unknown Exception encountered!');

    print(error.errorCode);

    if (error.statusCode == 401 && error.errorCode == 1002) {
      return element(
        'API key not provided.',
        TextStyle(fontSize: 30),
      );
    } else if (error.statusCode == 400 && error.errorCode == 1003) {
      return element(
        "Parameter 'q' not provided",
        TextStyle(fontSize: 30),
      );
    } else if (error.statusCode == 400 && error.errorCode == 1005) {
      return element(
        "1005 API request url is invalid",
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
      'Some Error Occured',
      TextStyle(fontSize: 30),
    );
  }

  void getWeather(
    BuildContext context,
    TextEditingController textController,
    WeatherEvent event,
  ) {
    BlocProvider.of<WeatherBloc>(context).add(event);
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var locationTextController = TextEditingController();
    // var deviceData = MediaQuery.of(context); //deviceData.viewInsets.bottom
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: BlocProvider(
        create: (context) => WeatherBloc()..add(FetchCurrentLocationWeather()),
        child: Builder(
          builder: (context) => BlocBuilder<WeatherBloc, WeatherState>(
            cubit: BlocProvider.of<WeatherBloc>(context), //will give error as this context does not have a bloc
            builder: (BuildContext context, WeatherState state) {
              if (state is LoadingWeather) return _showLoadingIndicator();

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Card(
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //     side: BorderSide(
                    //       color: Colors.grey,
                    //       width: 1.0,
                    //     ),
                    //   ),
                    //   margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(20.0),
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: <Widget>[
                    //         Text("Location:"),
                    //         DropDownSearch(),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    if (state.error != null) _showErrorLoadingIndicator(state),
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
                                      onPressed: () => getWeather(
                                        context,
                                        locationTextController,
                                        FetchCurrentLocationWeather(),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () => getWeather(
                                          context,
                                          locationTextController,
                                          FetchWeather(
                                              locationTextController.text)),
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
