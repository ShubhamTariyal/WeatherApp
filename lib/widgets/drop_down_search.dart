import 'package:WeatherApp/bloc/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class DropDownSearch extends StatefulWidget {
  @override
  _DropDownSearchState createState() => _DropDownSearchState();
}

class _DropDownSearchState extends State<DropDownSearch> {
  List<String> locations = [
    'Delhi',
    'London',
    'Mumbai',
    'Pune',
    'Delhi',
    'London',
    'Mumbai',
    'Pune',
    'Delhi',
    'London',
    'Mumbai',
    'Pune',
  ];
  @override
  Widget build(BuildContext context) {
    // var deviceData = MediaQuery.of(context); //deviceData.viewInsets.bottom
    // print("Height: ${deviceData.size.height} ViewInsets.bottom: ${deviceData.viewInsets.bottom}");
    var weatherBloc = BlocProvider.of<WeatherBloc>(context);
  List<DropdownMenuItem<String>> items = locations
        .map((item) => DropdownMenuItem<String>(
              child: Text(item),
              value: item,
            ))
        .toList();
    return BlocBuilder<WeatherBloc, WeatherState>(
      cubit: weatherBloc,
      builder: (context, state) {
        var selectedValue = state != null && state.weatherData != null ? state.weatherData.name:'';
    return SearchableDropdown.single(
          items: items,
          value: selectedValue,
          hint: "Select one",
          searchHint: null,
          onChanged: (value) {
            // setState(() {
              weatherBloc.add(FetchWeather(value));
            // });
          },
          dialogBox: false,
          isExpanded: true,
          menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
        );
      },
    );
    // return DropdownButton(
    //   // isExpanded: true,
    //   focusColor: Colors.red,
    //   icon: Icon(Icons.arrow_downward),
    //   value: v,
    //   items: [
    //     DropdownMenuItem<String>(
    //       child: Text('Hello'),
    //       value: 'Hello',
    //       onTap: () {},
    //     ),
    //     DropdownMenuItem<String>(
    //       child:items Text('Ok'),
    //       value: 'Ok',
    //       onTap: () {},
    //     ),
    //     DropdownMenuItem<String>(
    //       child: Text('Vak'),DropdownButton
    //       value: 'Vak',
    //     ),
    //   ],
    //   onChanged: (_) {
    //     setState(() {
    //       v = _;
    //     });
    //   },
    // );
  }
}
