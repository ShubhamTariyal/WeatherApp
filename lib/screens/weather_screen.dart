import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/weather_bloc.dart';
import '../constants.dart';
import '../widgets/text_with_button_widget.dart';
import '../widgets/auto_size_text_widget.dart';
import '../widgets/center_circular_progress_Indicator_widget.dart';
import '../utils/enable_gps_alert.dart';
import '../utils/enable_permission_alert.dart';
import '../modals/errors/error_loading_weather.dart';

class WeatherScreen extends StatelessWidget {
  static const routeName = '/';

  Widget _showWeatherInfo(WeatherState state) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal:5.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                '$weatherImagesBaseDirPath/${state.weatherData.isDay == 1 ? 'day' : 'night'}/${state.iconNo}.png',
                height: 60.r,
                fit: BoxFit.cover,
              ),
              FlexibleText(
                text: state.weatherData.conditionText,
                style: TextStyle(fontSize: 40.sp),
              ),
            ],
          ),
        ),
        FlexibleText(
          text: '${state.weatherData.tempC} \u2103',
          style: TextStyle(fontSize: 80.sp),
        ),
        FlexibleText(
          text: '$humidity: ${state.weatherData.humidity}%',
          style: TextStyle(fontSize: 25.sp),
        ),
        FlexibleText(
          text: '$windSpeed: ${state.weatherData.windKph} $unit',
          style: TextStyle(fontSize: 25.sp),
        ),
        FlexibleText(
          text: state.weatherData.name,
          style: TextStyle(fontSize: 50.sp),
        ),
      ],
    );
  }

  Widget _showErrorLoadingIndicator(
      WeatherExceptionState state, BuildContext context) {
    var error;

    if (state.error is ServiceNotEnabled) {
      error = state.error as ServiceNotEnabled;
      return TextWithButton(
        text: error.toString(),
        style: TextStyle(fontSize: 30.sp),
        handler: () => BlocProvider.of<WeatherBloc>(context)
            .add(FetchCurrentLocationWeather()),
      );
    } else if (state.error is PermissionDenied) {
      error = state.error as PermissionDenied;
      return FlexibleText(
        text: error.toString(),
        style: TextStyle(fontSize: 30.sp),
      );
    } else if (state.error is PermissionDeniedPermanently) {
      error = state.error as PermissionDeniedPermanently;
      return FlexibleText(
        text: error.toString(),
        style: TextStyle(fontSize: 30.sp),
      );
    }

    if (state.error is ErrorLoadingWeather) {
      error = state.error as ErrorLoadingWeather;
    } else {
      print("Unknown Exception:" + state.error.toString());
      return FlexibleText(
        text: unknownWeatherExceptionMessage,
        style: TextStyle(fontSize: 40.sp),
        maxLines: 4,
      );
      // throw Exception('Unknown Exception encountered!');
    }
    print(error.errorCode);

    if (error.statusCode == 401 && error.errorCode == 1002) {
      return FlexibleText(
        text: apiKeyNotProvidedMessage,
        style: TextStyle(fontSize: 30.sp),
      );
    } else if (error.statusCode == 400 && error.errorCode == 1003) {
      return FlexibleText(
        text: properQueryNotProvidedMessage,
        style: TextStyle(fontSize: 30.sp),
      );
    } else if (error.statusCode == 400 && error.errorCode == 1005) {
      return FlexibleText(
        text: invalidApiRequestUrlMessage,
        style: TextStyle(fontSize: 30.sp),
      );
    } else if (error.statusCode == 400 && error.errorCode == 1006) {
      return FlexibleText(
        text: noMatchingLocationMessage,
        style: TextStyle(fontSize: 30.sp),
      );
    } else if (error.statusCode == 401 && error.errorCode == 2006) {
      return FlexibleText(
        text: invalidApiKeyMessage,
        style: TextStyle(fontSize: 30.sp),
      );
    } else if (error.statusCode == 403 && error.errorCode == 2007) {
      return FlexibleText(
        text: callLimitExceededMessage,
        style: TextStyle(fontSize: 30.sp),
      );
    } else if (error.statusCode == 403 && error.errorCode == 2008) {
      return FlexibleText(
        text: apiKeyDisabledMessage,
        style: TextStyle(fontSize: 30.sp),
      );
    } else if (error.statusCode == 400 && error.errorCode == 9999) {
      return FlexibleText(
        text: internalApplicationErrorMessage,
        style: TextStyle(fontSize: 30.sp),
      );
    }
    return FlexibleText(
      text: otherErrorMessage,
      style: TextStyle(fontSize: 30.sp),
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
    var appBar = AppBar(
      title: Text(weatherApp),
    );
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: appBar,
      body: BlocConsumer<WeatherBloc, WeatherState>(
        cubit: BlocProvider.of<WeatherBloc>(
            context), //will give error as this context does not have a bloc
        listener: (BuildContext context, WeatherState state) {
          if (state is WeatherExceptionState &&
              state.error is ServiceWeatherException) {
            if (state.error is ServiceNotEnabled) {
              showEnableGPSDialoge(context);
              // if(await Geolocator.isLocationServiceEnabled())
              //   BlocProvider.of<WeatherBloc>(context).add(FetchCurrentLocationWeather());
              // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Trial')));
            } else if (state.error is PermissionDenied ||
                state.error is PermissionDeniedPermanently) {
              showEnablePermissionDialogue(askGpsPermissionMessage, context);
            }
            // else if (state.error is PermissionDeniedPermanently) {
            //   showEnablePermissionDialogue('Give GPS Permission', context);
            // }
          }
        },
        builder: (BuildContext context, WeatherState state) {
          print(MediaQuery.of(context).size.height);
          print(MediaQuery.of(context).size.width);
          if (state is WeatherInitial)
            BlocProvider.of<WeatherBloc>(context)
                .add(FetchCurrentLocationWeather());
          if (state is LoadingWeather) return CenterCircularProgressIndicator();

          return SingleChildScrollView(
            child: Container(
              height: 690.h - appBar.preferredSize.height - ScreenUtil().statusBarHeight - ScreenUtil().bottomBarHeight,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is WeatherExceptionState)
                    _showErrorLoadingIndicator(state, context),
                  if (state is CurrentWeather || state is CurrentLocationWeather)
                    _showWeatherInfo(state),
                    // SizedBox(height: 550.h, width: 300.w,child:FittedBox(child:
                  (){print('Height:${690.h - appBar.preferredSize.height - ScreenUtil().statusBarHeight - ScreenUtil().bottomBarHeight}|${ScreenUtil().screenHeight} |appbar Height:${appBar.preferredSize.height}|statusBarHeight:${ScreenUtil().statusBarHeight} | bottombarheight:${ScreenUtil().bottomBarHeight}');
                  return Container();}(),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      side: BorderSide(
                        color: Colors.grey,
                        width: 1.0.r,
                      ),
                    ),
                    margin: EdgeInsets.all(5.r),
                    child: Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Container(
                        // height: 50.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            FittedBox(
                              child: Text(
                                "$location:",
                                style: TextStyle(fontSize: 16.h),
                              ),
                            ),
                            TextField(
                              textInputAction: TextInputAction.done,
                              controller: locationTextController,
                              style: TextStyle(fontSize: 16.h),
                              decoration: InputDecoration(
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      iconSize: 24.r,
                                      icon: Icon(Icons.my_location),
                                      onPressed: () =>
                                          BlocProvider.of<WeatherBloc>(context)
                                              .add(FetchCurrentLocationWeather()),
                                    ),
                                    IconButton(
                                      iconSize: 24.r,
                                      icon: Icon(Icons.search),
                                      onPressed: () => getWeather(
                                        context,
                                        locationTextController,
                                        FetchWeather(locationTextController.text),
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
