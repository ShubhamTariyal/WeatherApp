import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weather_bloc.dart';
import '../widgets/drop_down_search.dart';

class WeatherScreen extends StatelessWidget {
  static const routeName = '/';

  Widget _showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _showWeatherInfo(WeatherState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/weather/64x64/${state.weatherData.isDay == 1 ? 'day' : 'night'}/${state.iconNo}.png',
            ),
            Flexible(
              child: Text(
                state.weatherData.conditionText,
                style: TextStyle(fontSize: 40),
                softWrap: true,
              ),
            ),
          ],
        ),
        Text(
          '${state.weatherData.tempC} \u2103',
          style: TextStyle(fontSize: 80),
        ),
        Text(
          'Humidity: ${state.weatherData.humidity}%',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Wind Speed: ${state.weatherData.windKph}kmph',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '${state.weatherData.name}',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _showErrorLoadingIndicator(ErrorLoadingWeather state) {
    print(state.errorCode);
    if (state.statusCode == 401 && state.errorCode == 1002) {
      return Text(
        'API key not provided.',
        style: TextStyle(
          fontSize: 30,
        ),
        softWrap: true,
      );
    } else if (state.statusCode == 400 && state.errorCode == 1003) {
      return Text(
        "Parameter 'q' not provided",
        style: TextStyle(
          fontSize: 30,
        ),
        softWrap: true,
      );
    } else if (state.statusCode == 400 && state.errorCode == 1005) {
      return Text(
        "1005 API request url is invalid",
        style: TextStyle(
          fontSize: 30,
        ),
        softWrap: true,
      );
    } else if (state.statusCode == 400 && state.errorCode == 1006) {
      return Text(
        'No matching location found',
        style: TextStyle(
          fontSize: 30,
        ),
        softWrap: true,
      );
    } else if (state.statusCode == 401 && state.errorCode == 2006) {
      return Text(
        'API key provided is invalid',
        style: TextStyle(
          fontSize: 30,
        ),
        softWrap: true,
      );
    } else if (state.statusCode == 403 && state.errorCode == 2007) {
      return Text(
        'API key has exceeded calls per month quota',
        style: TextStyle(
          fontSize: 30,
        ),
        softWrap: true,
      );
    } else if (state.statusCode == 403 && state.errorCode == 2008) {
      return Text(
        'API key has been disabled',
        style: TextStyle(
          fontSize: 30,
        ),
        softWrap: true,
      );
    } else if (state.statusCode == 400 && state.errorCode == 9999) {
      return Text(
        'Internal application error',
        style: TextStyle(
          fontSize: 30,
        ),
        softWrap: true,
      );
    }
    return Text(
      'Some Error Occured',
      style: TextStyle(
        fontSize: 30,
      ),
      softWrap: true,
    );
  }

  void getWeather(BuildContext context, TextEditingController textController) {
    BlocProvider.of<WeatherBloc>(context).add(
      FetchWeather(textController.text),
    );
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
        create: (context) => WeatherBloc(),
        child: Builder(
          builder: (context) => BlocBuilder<WeatherBloc, WeatherState>(
            cubit: BlocProvider.of<WeatherBloc>(
                context), //will give error as this context does not have a bloc
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
                    if (state is ErrorLoadingWeather)
                      _showErrorLoadingIndicator(state),
                    if (state is CurrentWeather) _showWeatherInfo(state),
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
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () => getWeather(
                                      context, locationTextController),
                                ),
                              ),
                              onSubmitted: (location) =>
                                  getWeather(context, locationTextController),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.all(10),
                    //   margin: EdgeInsets.all(10),
                    //   child: TextField(
                    //     controller: locationTextController,
                    //   ),
                    // ),
                    // RaisedButton(
                    //   child: Text('Get Current Weather'),
                    //   onPressed: () {},
                    // ),Builder
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
